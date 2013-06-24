default : clean install

clean:
        rm -f $(HOME)/bin/iPublish

install:
        @PWD=`pwd`
        ln -s $(PWD)/iPublish $(HOME)/bin/iPublish

.PHONY: clean install
