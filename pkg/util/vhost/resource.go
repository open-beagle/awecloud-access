// Copyright 2017 fatedier, fatedier@gmail.com
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package vhost

import (
	"bytes"
	"io"
	"net/http"
	"os"

	logpkg "github.com/fatedier/frp/pkg/util/log"
	"github.com/fatedier/frp/pkg/util/version"
)

var NotFoundPagePath = ""

const (
	NotFound = `<!DOCTYPE html>
<html>
<head>
<title>Not Found</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>服务已中断.</h1>
<p>提示： 您访问的页面出现错误，请联系管理员.<br/></p>
<p>The server is powered by <a href="https://www.bd-apaas.com">Beagle Cloud Team</a>.</p>
<p><em>请稍后再试.</em></p>
</body>
</html>
`
)

func getNotFoundPageContent() []byte {
	var (
		buf []byte
		err error
	)
	if NotFoundPagePath != "" {
		buf, err = os.ReadFile(NotFoundPagePath)
		if err != nil {
			logpkg.Warn("read custom 404 page error: %v", err)
			buf = []byte(NotFound)
		}
	} else {
		buf = []byte(NotFound)
	}
	return buf
}

func NotFoundResponse() *http.Response {
	header := make(http.Header)
	header.Set("server", "beagle-access/"+version.Full())
	header.Set("Content-Type", "text/html")

	content := getNotFoundPageContent()
	res := &http.Response{
		Status:        "Not Found",
		StatusCode:    404,
		Proto:         "HTTP/1.1",
		ProtoMajor:    1,
		ProtoMinor:    1,
		Header:        header,
		Body:          io.NopCloser(bytes.NewReader(content)),
		ContentLength: int64(len(content)),
	}
	return res
}
