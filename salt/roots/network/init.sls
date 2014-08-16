{% if grains['os'] == 'Windows' %}
C:/Windows/System32/drivers/etc/hosts:
{% else %}
/etc/hosts:
{% endif %}
  file.managed:
    - source: salt://network/hosts.jinja
{% if grains['os'] == 'Windows' %}
{% else %}
    - user: root
    - group: root
    - mode: 644
{% endif %}
    - template: jinja