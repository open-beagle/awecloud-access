package net

import (
	"context"
	"crypto/tls"
	"net"
	"net/url"

	libdial "github.com/fatedier/golib/net/dial"
	"golang.org/x/net/websocket"
)

func DialHookCustomTLSHeadByte(enableTLS bool, disableCustomTLSHeadByte bool) libdial.AfterHookFunc {
	return func(ctx context.Context, c net.Conn, addr string) (context.Context, net.Conn, error) {
		if enableTLS && !disableCustomTLSHeadByte {
			_, err := c.Write([]byte{byte(FRPTLSHeadByte)})
			if err != nil {
				return nil, nil, err
			}
		}
		return ctx, c, nil
	}
}

func DialHookWebsocket(protocol string, host string) libdial.AfterHookFunc {
	return func(ctx context.Context, c net.Conn, addr string) (context.Context, net.Conn, error) {
		if protocol != "wss" {
			protocol = "ws"
		}
		if host == "" {
			host = addr
		}
		addr = protocol + "://" + host + FrpWebsocketPath
		uri, err := url.Parse(addr)
		if err != nil {
			return nil, nil, err
		}

		origin := "http://" + uri.Host
		cfg, err := websocket.NewConfig(addr, origin)
		if err != nil {
			return nil, nil, err
		}

		conn, err := websocket.NewClient(cfg, c)
		if err != nil {
			return nil, nil, err
		}
		return ctx, conn, nil
	}
}

func DialHookWSS() libdial.AfterHookFunc {
	return func(ctx context.Context, c net.Conn, addr string) (context.Context, net.Conn, error) {
		addr = "wss://" + addr + FrpWebsocketPath
		uri, err := url.Parse(addr)
		if err != nil {
			return nil, nil, err
		}

		origin := "https://" + uri.Host
		cfg, err := websocket.NewConfig(addr, origin)
		if err != nil {
			return nil, nil, err
		}
		cfg.TlsConfig = &tls.Config{
			InsecureSkipVerify: true,
		}

		conn, err := websocket.DialConfig(cfg)
		if err != nil {
			return nil, nil, err
		}
		return ctx, conn, nil
	}
}
