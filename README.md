![XFLR5 Logo](http://www.xflr5.tech/images/XFLR5_Logo.png)

# XFLR5

XFLR5 is an analysis tool for airfoils, wings and planes operating at low Reynolds Numbers. Please visit the [official XFLR5 home page](http://www.xflr5.tech/xflr5.htm) for further information.

This image provides an already build XFLR5 based on Linux, so you can directly start with XFLR5 without any additional installation needed.

# How to run:

```
xhost +

docker run \
	-it \
	--rm \
	--env=LOCAL_USER_ID="$(id -u)" \
	-e DISPLAY=unix$DISPLAY \
	--device="/dev/video0:/dev/video0" \
	-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
	-v ${PWD}:/xflr5 \
	xflr5
```
The volume _/xflr5_ is foreseen as shared folder to the host for project files.

A ready to go run script is available with [xflr5](xflr5).

# Tags available

| XFLR5    | Qt       | underlaying OS     | Tags           |
|:--------:|:---------|:-------------------|:---------------|
| 6.47     | 5.11.2   | Debian Buster-Slim | 6.47; latest   |
