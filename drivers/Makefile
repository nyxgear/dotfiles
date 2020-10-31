PRODUCT_NAME = $(shell sudo dmidecode -s system-product-name)
	
all: fix-NVIDIA-Intel-gc-switch


fix-NVIDIA-Intel-gc-switch:
	@ #https://forums.developer.nvidia.com/t/nvidia-xconfig-doesnt-do-what-i-want-it-to-nor-does-nvidia-settings/107883/7
	
        ifneq ($(PRODUCT_NAME),XPS 15 7590)
	    @echo $@ applies only for model: XPS 15 7590. Current is: $(PRODUCT_NAME). Skipping $@...
        else
	    sudo cp ./xorg.conf /etc/X11/
	    # xrandr --auto
	    @echo Done.
        endif

