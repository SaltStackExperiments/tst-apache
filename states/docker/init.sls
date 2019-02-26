# subscript-rhel-y-server-extras-rpms:
#   cmd.run:
#     - name: "subscription-manager repos --enable=rhel-7-server-extras-rpms"

docker_repo_added:
  cmd.run:
    - name: "yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo"

# docker_repo_added:
#   pkgrepo.managed:
#     - name: docker-ce
#     - enabled: True
#     - baseurl: https://download.docker.com/linux/centos/docker-ce.repo
#     - refresh: True

docker-installed:
  pkg.installed: 
    - names:
      - yum-utils
      - device-mapper-persistent-data
      - lvm2
      - docker-ce
      - docker-ce-cli
      - containerd.io
    - require:
      - docker_repo_added

pip_installed:
  pkg.installed:
    - name: python2-pip

docker_py_installed:
  pip.installed:
    - name: "docker-py>=1.4.0"
    - require:
      - pip_installed

docker_running:
  service.running:
    - name: docker
    - enable: True
    - require:
      - docker-installed
