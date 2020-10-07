# docker-nginx-redirect

A very simple container to redirect HTTP traffic to another server, based on `nginx`

## Configuration

### Environment variables

Opertes in two modes, `proxy` and `redirect

See also `docker-compose.yml` file.


#### General Options

The following engiernment variables can be set in any mode.

- `SERVER_NAME` - optionally define the server name to listen on eg. `~^www.(?<subdomain>.+).example.com`
   - useful for capturing variable to use in server_redirect. 
- `SERVER_ACCESS_LOG` - optionally define the location where nginx will write its access log
   - if not set /dev/stdout is used
- `SERVER_ERROR_LOG` - optionally define the location where nginx will write its error log
   - if not set /dev/stderr is used

#### Proxy Options

- `PROXY_HOST` - The IP or hostname of the destination server to proxy to.  This setting triggers the proxy 
                 mode. Only the additional variables listed below will will work in proxy mode.
- `PROXY_PORT` - The destination port to proxy to.
- `PROXY_SSL_PORT` - An optional argument for a SSL port to redirect to. If left blank ssl will not redirect

#### Redirect Options

- `SERVER_REDIRECT` - server to redirect to, eg. `www.example.com`. This setting triggers redirect mode. Only
                      the additional variables listed below will wok in redirect mode.
- `SERVER_REDIRECT_PATH` - optionally define path to redirect all requests eg. `/landingpage`
   - if not set nginx var `$request_uri` is used
- `SERVER_REDIRECT_SCHEME` - optionally define scheme to redirect to 
   - if not set but X-Forwarded-Proto is send as request header with value 'https' this will be used. 
     In all other cases nginx var `$scheme` is used
- `SERVER_REDIRECT_CODE` - optionally define the http status code to use for redirection
   - if not set or not in list of allowed codes 301 is used as default
   - allowed Codes are: 301, 302, 303, 307, 308
 - `SERVER_REDIRECT_POST_CODE` - optionally define the http code to use for POST redirection
    - useful if client should not change the request method from POST to GET
    - if not set or not in allowed Codes `SERVER_REDIRECT_CODE` is used
    - so per default all requests will be redirected with the same status code
 - `SERVER_REDIRECT_PUT_PATCH_DELETE_CODE` - optionally define the http code to use for PUT, PATCH and DELETE redirection
    - useful if client should not change the request method from PUT, PATCH and DELETE to GET
    - if not set or not in allowed Codes `SERVER_REDIRECT_CODE` is used
    - so per default all requests will be redirected with the same status code

## Usage

With `docker-compose`

````bash
docker-compose up -d
````
    
With `docker`    

```bash
docker run -e SERVER_REDIRECT=www.example.com -p 8888:80 schmunk42/nginx-redirect
docker run -e SERVER_REDIRECT=www.example.com -e SERVER_REDIRECT_PATH=/landingpage -p 8888:80 schmunk42/nginx-redirect
docker run -e SERVER_REDIRECT=www.example.com -e SERVER_REDIRECT_PATH=/landingpage -e SERVER_REDIRECT_SCHEME=https -p 8888:80 schmunk42/nginx-redirect
```
## Resources

This tool was adapted from the original you can get at [Github](https://github.com/schmunk42/docker-nginx-redirect)
