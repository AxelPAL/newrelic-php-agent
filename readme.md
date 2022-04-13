# newrelic-php-agent

This image is used for multi-stage build of your dockerized app.
It is based on https://github.com/newrelic/newrelic-php-agent and inside this image you can find next things:

* Compiled php-extension for AMD64, ARM64, ARMv7 architectures for next versions of PHP:
  * 7.4
  * 8.0
  * 8.1
* bin folder that contains compiled version of NewRelic's:
  * daemon
  * client
  * integration_runner
  * stressor
* config folder with newrelic config template

Full hierarchy of output folder of this image (/output):
* bin
  * daemon
  * client
  * integration_runner
  * stressor
* config
  * newrelic.ini.template
* extension
  * 7.4
    * newrelic.so
  * 8.0
    * newrelic.so
  * 8.1
    * newrelic.so

## Usage

Inside your Dockerfile:

```dockerfile
FROM axelpal/newrelic-php-agent AS newrelic-php-agent
...
COPY --from=newrelic-php-agent /output/extension/8.0/newrelic.so /usr/lib/php/20200930/newrelic.so
COPY --from=newrelic-php-agent /output/bin/* /usr/bin
```

You should replace ${PHP_VERSION} with your current version of php and also you should specify the path to your php extensions dir:
In Debian/Ubuntu by default it is:
* `/usr/lib/php/20190902` for PHP 7.4
* `/usr/lib/php/20200930` for PHP 8.0
* `/usr/lib/php/20210902` for PHP 8.1

You also should grab NewRelic's template for php extension and fill it out (config/newrelic.ini.template). After that you should use it inside your container with your app to configure NewRelic's php extension.
