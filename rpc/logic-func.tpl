{{if .hasComment}}{{.comment}}{{end}}
func (l *{{.logicName}}) {{.method}} ({{if .hasReq}}in {{.request}}{{if .stream}},stream {{.streamBody}}{{end}}{{else}}stream {{.streamBody}}{{end}}) ({{if .hasReply}}{{.response}},{{end}} error) {
	{{if .hasReply}}
	// caching goes logic here
	if entry{{.logicName}} == nil {
		l.mu.Lock()
		entry{{.logicName}} = &galaxy{{.logicName}}Helper{
			once: &sync.Once{},
		}
		l.mu.Unlock()
	}

	entry{{.logicName}}.once.Do(func() {
		fmt.Println(`l.entry{{.logicName}}.Do`)

		// register the galaxy one time
		entry{{.logicName}}.galaxy = gcache.RegisterGalaxyFunc("{{.method}}", l.universe, galaxycache.GetterFunc(
			func(ctx context.Context, key string, dest galaxycache.Codec) error {
				// todo: add your logic here and delete this line
				fmt.Printf("Looking up {{.method}} record by key: %s", key)

				// uncomment below to get the item from the adapter
				// found, err := l.ca.GetProductBySku(key)
				// if err != nil {
				//	logx.Infof("error: %s", err)
				//	return err
				// }


				// the response struct
				item := &{{.responseType}}{}

				out, err := json.Marshal(item)
				if err != nil {
					return err
				}
				return dest.UnmarshalBinary(out)
			}))
	})
	{{end}}
	
	{{if .hasReply}}
	res := &{{.responseType}}{}

	codec := &galaxycache.ByteCodec{}
	if err := entry{{.logicName}}.galaxy.Get(l.ctx, in.Id, codec); err != nil {
		res.StatusCode = http.StatusNoContent
		res.StatusMessage = err.Error()
		return res, nil
	}

	b, err := codec.MarshalBinary()
	if err != nil {
		res.StatusCode = http.StatusInternalServerError
		res.StatusMessage = err.Error()
		return res, nil
	}
	
	err = json.Unmarshal(b, res)
	return res, err
	{{else}}
	return err
	{{end}}
}
