{{.head}}

package server

import (
	{{if .notStream}}"context"{{end}}

	{{.imports}}

	"github.com/localrivet/galaxycache"
)

type {{.server}}Server struct {
	svcCtx *svc.ServiceContext
	universe *galaxycache.Universe
}

func New{{.server}}Server(svcCtx *svc.ServiceContext, universe *galaxycache.Universe) *{{.server}}Server {
	return &{{.server}}Server{
		svcCtx: svcCtx,
		universe: universe,
	}
}

{{.funcs}}
