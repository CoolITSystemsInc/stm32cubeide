[#ftl]
[#if outputs??]
[#list outputs as output]
[#list output.entrySet() as entry]
[#if entry.key != "Sources"]
[#if entry.key == "Includes"]HeaderPath[#else]${entry.key}[/#if] = [#list entry.value as file]${file};[/#list]#n
[/#if]
[/#list]
[/#list]
[/#if]