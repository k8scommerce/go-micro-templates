package logic

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"sync"
	{{.imports}}

	"github.com/localrivet/gcache"
	"github.com/tal-tech/go-zero/core/logx"
	"github.com/localrivet/galaxycache"
)

type galaxy{{.logicName}}Helper struct {
	once   *sync.Once
	galaxy *galaxycache.Galaxy
}

var entry{{.logicName}} *galaxy{{.logicName}}Helper

type {{.logicName}} struct {
	ctx    context.Context
	svcCtx *svc.ServiceContext
	logx.Logger
	universe *galaxycache.Universe
	mu       sync.Mutex
}

func New{{.logicName}}(ctx context.Context,svcCtx *svc.ServiceContext, universe *galaxycache.Universe) *{{.logicName}} {
	return &{{.logicName}}{
		ctx:    ctx,
		svcCtx: svcCtx,
		Logger: logx.WithContext(ctx),
		universe: universe,
	}
}
{{.functions}}
