NET_NAME = test-net
VM_NAME = aio-test
VOL_NAME = $(VM_NAME).qcow2

clean: destroy-libvirt
	rm -rf mydir

destroy-libvirt:
	echo "Destroying previous libvirt resources"
	NET_NAME=$(NET_NAME) \
        VM_NAME=$(VM_NAME) \
        VOL_NAME=$(VOL_NAME) \
        ./virt-delete-aio.sh || true

generate:
	mkdir mydir
	cp ./install-config.yaml mydir/
	OPENSHIFT_INSTALL_RELEASE_IMAGE_OVERRIDE="quay.io/openshift-release-dev/ocp-release:4.7.0-fc.5-x86_64" ./bin/openshift-install create aio-config --dir=mydir

# the resulting VM will pull it's configuration from: http://device-management.redhat.edge-lab.net/netboot/x86_64/ignition/52:54:00:ee:42:e5
# In order to start the installation process login (make ssh) and start the aiokube service (systemctl start aiokube)
start: network
	./virt-start-aio.sh

network:
	./virt-create-net.sh
.PHONY: ssh
ssh:
	chmod 400 ./ssh/key
	sshpass -p redhat ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no redhat@192.168.126.10

image:
	curl -O -L http://cdn.redhat.edge-lab.net/releases/fiot-pods/latest/x86_64/fiot-pods.img
	mv fiot-pods.img /tmp/
