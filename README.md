![](tor-project-logo.svg)

An image based on Alpine Linux with [Tor](https://www.torproject.org/), [Privoxy](https://www.privoxy.org/) and [Squid](http://www.squid-cache.org/).

# Background

Tor provides a SOCKS proxy. We use Privoxy to add an HTTP proxy.

# Docker Image

These ports are exposed by the image:

- `9050` ⁠— Tor control port
- `9051` ⁠— Tor [SOCKS5](https://en.wikipedia.org/wiki/SOCKS) proxy and
- `8888` ⁠— Tor HTTP proxy.

### Build

A pre-built image is available [here](https://hub.docker.com/repository/docker/datawookie/tor-privoxy). Pull it using:

```bash
$ docker pull datawookie/tor-privoxy
```

You can also build your own using this repository:

```bash
$ docker build -t tor-privoxy .
```

Or use the `Makefile` as follow:

```bash
$ make build
```

### Run

To launch the pre-built image:

```bash
docker run -p 8888:8888 -p 9050:9050 --network="host" datawookie/tor-privoxy
```

You can also launch the image built from this repository:

```bash
docker run -p 8888:8888 -p 9050:9050 --network="host" tor-privoxy
```

Or use the `Makefile` as follow:

```bash
$ make run
```

### Environment Variables

The following environment variables will modify the behaviour of the container:

- `IP_CHANGE_SECONDS` - Number of seconds between changes of Tor exit address.

### Check

To check that you are on Tor:

- configure your browser to use 127.0.0.1:8888 as proxy then
- browse to https://check.torproject.org/.

## Using Tor

### Shell

```bash
# Direct access to internet.
$ curl http://httpbin.org/ip
{
  "origin": "105.224.106.154"
}
# Access internet through Tor (HTTP proxy).
$ curl --proxy 127.0.0.1:8888 http://httpbin.org/ip
{
  "origin": "64.113.32.29"
}
# Access internet through Tor (SOCKS proxy).
$ curl --proxy socks5://127.0.0.1:9050 http://httpbin.org/ip
{
  "origin": "144.217.255.89"
}
```

You get a different IP address when you send the request via the proxy. If you wait a while and then send the request again, you'll find that the IP address has changed.

### Python

The [stem](https://stem.torproject.org/) package exposes functionality for interacting with the Tor controller interface.

```bash
pip3 install stem
```

Use the requests package to send requests via the Tor proxies.

```python
>>> import requests
>>> requests.get("http://httpbin.org/ip").json()
{'origin': '105.224.106.154'}
>>> requests.get("http://httpbin.org/ip", proxies={"http": "http://127.0.0.1:8888"}).json()
{'origin': '64.113.32.29'}
>>> requests.get("http://httpbin.org/ip", proxies={"http": "socks5://127.0.0.1:9050"}).json()
{'origin': '144.217.255.89'}
```

This assumes that you've installed the `requests` module with support for SOCKS5.

```bash
pip3 install -U requests[socks]
```

### R

```r
> library(httr)
> GET("http://httpbin.org/ip")
{
  "origin": "105.224.106.154"
}
> GET("http://httpbin.org/ip", use_proxy("http://127.0.0.1:8888"))
{
  "origin": "64.113.32.29"
}
> GET("http://httpbin.org/ip", use_proxy("socks5://127.0.0.1:9050"))
{
  "origin": "144.217.255.89"
}
```

## Similar Projects

- https://github.com/mattes/rotating-proxy (Provides access to multiple simultaneous Tor proxies)
- https://github.com/wallneradam/docker-tor-proxy
- https://hub.docker.com/r/dperson/torproxy and https://github.com/dperson/torproxy