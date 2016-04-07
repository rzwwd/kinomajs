<?xml version="1.0" encoding="UTF-8"?>
<!--   
|     Copyright (C) 2010-2016 Marvell International Ltd.
|     Copyright (C) 2002-2010 Kinoma, Inc.
|
|     Licensed under the Apache License, Version 2.0 (the "License");
|     you may not use this file except in compliance with the License.
|     You may obtain a copy of the License at
|
|      http://www.apache.org/licenses/LICENSE-2.0
|
|     Unless required by applicable law or agreed to in writing, software
|     distributed under the License is distributed on an "AS IS" BASIS,
|     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
|     See the License for the specific language governing permissions and
|     limitations under the License.
-->
<makefile>
	<input name="$(F_HOME)/core/base"/>
	<input name="$(F_HOME)/core/graphics"/>
	<input name="$(F_HOME)/core/managers"/>
	<input name="$(F_HOME)/core/misc"/>
	<input name="$(F_HOME)/core/network"/>
	<input name="$(F_HOME)/core/ui"/>
	<input name="$(F_HOME)/extensions/crypt/sources"/>
	<input name="$(F_HOME)/libraries/QTReader"/>

	<input name="$(F_HOME)/build/linux/kpl"/>
	<input name="$(F_HOME)/core/kpl"/>
	<input name="$(F_HOME)/libraries/libjpeg"/>

	<header name="FskPlatform.h"/>
    <input name="$(F_HOME)/libraries/freetype/include"/>
	
	<source name="KplScreenLinuxNULL.c"/>
	<source name="KplAudioLinuxALSA.c"/>

	<library name="-Wl,-z,muldefs"/>
	<library name="-lasound"/>
	<library name="-ldl"/>
	<library name="-lrt"/>
	<library name="-lpthread"/>
	<library name="-lresolv"/>
	<library name="-lm"/>

	<c option="-m32"/>
	<c option="-march=core2"/>
	<c option="-mtune=core2"/>
	<c option="-msse3"/>
	<c option="-mfpmath=sse"/>
	<c option="-mstackrealign"/>
	<c option="-fno-omit-frame-pointer"/>
	
	<c option="-DBAD_FTRUNCATE=1"/>
	<c option="-DCLOSED_SSL=1"/>
	<c option="-DFSK_APPLICATION_$(FSK_APPLICATION)=1"/>
	<c option="-DFSK_EMBED=1"/>
	<c option="-DFSK_EXTENSION_EMBED=1"/>
	<c option="-DFSK_TEXT_FREETYPE=1"/>
	<c option="-DKIDFLIX_ROTATE=0"/>
	<c option="-DKPL=1"/>
	<c option="-DKPR_CONFIG=1"/>
	<c option="-DSUPPORT_QT=1"/>
	<c option="-DUSE_ASYNC_RESOLVER=1 "/>
	<c option="-DUSE_POLL=1"/>
	<c option="-DUSE_POSIX_CLOCK=1"/>
	<c option="-D_FILE_OFFSET_BITS=64"/>
	<c option="-D_LARGEFILE64_SOURCE"/>
	<c option="-D_LARGEFILE_SOURCE"/>
	<c option="-D_REENTRANT"/>
	<c option="-DEDISON=1"/>
	<c option="-D__FSK_LAYER__=1"/>
	<c option="-fsigned-char"/>
	<c option="-Wall"/>
	<c option="-Werror-implicit-function-declaration"/>
	<c option="-Wno-multichar"/>
	
	<version name="debug">
		<c option="-DmxDebug"/>
		<c option="-g"/>
	</version>
	
	<version name="release">
		<c option="-g"/>
		<c option="-O2"/>
	</version>
</makefile>
