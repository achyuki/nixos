{ config, pkgs, ... }:
{
  boot.kernelModules = [ "bpf" ];
  services.dae = {
    enable = true;
    config = ''
      global {
        wan_interface: auto
        log_level: info
        allow_insecure: false
        auto_config_kernel_parameter: true
      }
      dns {
        upstream {
          googledns: 'tcp+udp://dns.google:53'
          alidns: 'udp://dns.alidns.com:53'
        }
        routing {
          request {
            fallback: alidns
          }
          response {
            upstream(googledns) -> accept
            ip(geoip:private) && !qname(geosite:cn) -> googledns
            fallback: accept
          }
        }
      }
      node {
        clash: 'socks5://127.0.0.1:7890'
      }
      group {
        clash {
          policy: fixed(0)
        }
      }
      routing {
        pname(clash, clash-meta, clash-verge, mihomo, flclash) -> must_direct

        pname(tailscale) -> must_direct
        pname(tailscaled) -> must_direct
        pname(wechat, WeChatAppEx) -> must_direct
        pname(qq) -> must_direct

        pname(NetworkManager) -> must_direct
        dip(224.0.0.0/3, 'ff00::/8') -> must_direct
        dip(127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16) -> must_direct

        # 禁用 h3，因为它通常消耗很多 CPU 和内存资源
        l4proto(udp) && dport(443) -> block
        dip(geoip:private) -> direct
        dip(geoip:cn) -> direct
        domain(geosite:cn) -> direct

        fallback: clash
      }
    '';
  };
}
