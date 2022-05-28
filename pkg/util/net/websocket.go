package net

import (
	"crypto/tls"
	"errors"
	"net"
	"net/http"
	"net/url"
	"strconv"
	"time"

	"golang.org/x/net/websocket"
)

var (
	ErrWebsocketListenerClosed = errors.New("websocket listener closed")
	// FrpWebsocketPath           = "/~!frp"
	FrpWebsocketPath = "/rms/api"
)

type WebsocketListener struct {
	ln       net.Listener
	acceptCh chan net.Conn

	server    *http.Server
	httpMutex *http.ServeMux
}

// NewWebsocketListener to handle websocket connections
// ln: tcp listener for websocket connections
func NewWebsocketListener(ln net.Listener) (wl *WebsocketListener) {
	wl = &WebsocketListener{
		acceptCh: make(chan net.Conn),
	}

	muxer := http.NewServeMux()
	muxer.Handle(FrpWebsocketPath, websocket.Handler(func(c *websocket.Conn) {
		notifyCh := make(chan struct{})
		conn := WrapCloseNotifyConn(c, func() {
			close(notifyCh)
		})
		wl.acceptCh <- conn
		<-notifyCh
	}))

	wl.server = &http.Server{
		Addr:    ln.Addr().String(),
		Handler: muxer,
	}

	go wl.server.Serve(ln)
	return
}

func ListenWebsocket(bindAddr string, bindPort int) (*WebsocketListener, error) {
	tcpLn, err := net.Listen("tcp", net.JoinHostPort(bindAddr, strconv.Itoa(bindPort)))
	if err != nil {
		return nil, err
	}
	l := NewWebsocketListener(tcpLn)
	return l, nil
}

func (p *WebsocketListener) Accept() (net.Conn, error) {
	c, ok := <-p.acceptCh
	if !ok {
		return nil, ErrWebsocketListenerClosed
	}
	return c, nil
}

func (p *WebsocketListener) Close() error {
	return p.server.Close()
}

func (p *WebsocketListener) Addr() net.Addr {
	return p.ln.Addr()
}

// addr: domain:port
func ConnectWebsocketServer(addr string) (net.Conn, error) {
	addr = "ws://" + addr + FrpWebsocketPath
	uri, err := url.Parse(addr)
	if err != nil {
		return nil, err
	}

	origin := "http://" + uri.Host
	cfg, err := websocket.NewConfig(addr, origin)
	if err != nil {
		return nil, err
	}
	cfg.Dialer = &net.Dialer{
		Timeout: 10 * time.Second,
	}

	conn, err := websocket.DialConfig(cfg)
	if err != nil {
		return nil, err
	}
	return conn, nil
}

// addr: domain:port
func ConnectWSSServer(addr string) (net.Conn, error) {
	addr = "wss://" + addr + FrpWebsocketPath
	uri, err := url.Parse(addr)
	if err != nil {
		return nil, err
	}

	origin := "https://" + uri.Host
	cfg, err := websocket.NewConfig(addr, origin)
	if err != nil {
		return nil, err
	}
	cfg.Dialer = &net.Dialer{
		Timeout: 10 * time.Second,
	}
	cfg.TlsConfig = &tls.Config{
		InsecureSkipVerify: true,
	}

	conn, err := websocket.DialConfig(cfg)
	if err != nil {
		return nil, err
	}
	return conn, nil
}
