workspace "skygfx_vc"
    system "Windows"
    architecture "x86"
    configurations { "Release", "DebugIII", "DebugVC" }
    location "build"

    language "C++"
    cppdialect "C++latest"
    multiprocessorcompile "On"
    warnings "Extra"
    disablewarnings { "4458", "4706", "4201", "4740" }
    buildoptions { "/Zc:threadSafeInit-" }

    files { "shaders/*.*", "src/*.*" }
    includedirs { "shaders", "src", os.getenv("RWSDK34") }
    includedirs { "external/injector/include", "external/rwd3d9/source", "../rwd3d9/source" }
    
    -- Injector submodules (kananlib, bddisasm, safetyhook)
    defines { "BDDISASM_HAS_MEMSET", "BDDISASM_HAS_VSNPRINTF" }
    includedirs { "external/injector/kananlib/include" }
    includedirs { "external/injector/bddisasm/inc" }
    includedirs { "external/injector/bddisasm/bddisasm/include" }
    includedirs { "external/injector/safetyhook/include" }

    libdirs { "external/rwd3d9/libs", "../rwd3d9/libs" }
    links { "rwd3d9.lib" }
   
    prebuildcommands {
        "for /R \"../shaders/ps/\" %%f in (*.hlsl) do \"%DXSDK_DIR%/Utilities/bin/x86/fxc.exe\" /T ps_2_0 /nologo /E main /Fh ../shaders/%%~nf.h %%f",
        "for /R \"../shaders/vs/\" %%f in (*.hlsl) do \"%DXSDK_DIR%/Utilities/bin/x86/fxc.exe\" /T vs_2_0 /nologo /E main /Fh ../shaders/%%~nf.h %%f",
    }
      
project "skygfx_vc"
    kind "SharedLib"
    targetname "skygfx"
    targetdir "bin/%{cfg.buildcfg}"
    targetextension ".dll"
    characterset "Unicode"

    filter "configurations:DebugIII"
        defines { "DEBUG" }
        symbols "On"
        debugdir "C:/Users/aap/games/gta3"
        debugcommand "C:/Users/aap/games/gta3/gta3.exe"
        postbuildcommands "copy /y \"$(TargetPath)\" \"C:\\Users\\aap\\games\\gta3\\plugins\\skygfx.dll\""

    filter "configurations:DebugVC"
        defines { "DEBUG" }
        symbols "On"
        debugdir "C:/Users/aap/games/gtavc"
        debugcommand "C:/Users/aap/games/gtavc/gta_vc.exe"
        postbuildcommands "copy /y \"$(TargetPath)\" \"C:\\Users\\aap\\games\\gtavc\\plugins\\skygfx.dll\""

    filter "configurations:Release"
        defines { "NDEBUG" }
        
        optimize "Speed"
        linktimeoptimization "On"
        vectorextensions "AVX2"
        largeaddressaware "On"
        rtti "Off"
        exceptionhandling "On"
        symbols "Off"
        omitframepointer "On"
        buildoptions { "/Gw", "/Zc:preprocessor" }
