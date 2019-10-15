[#ftl]

[#list configs as dt]
[#compress]
	[#assign data = dt]
	[#assign dtPinCtrlDataModelNoZ = dt.dtPinCtrlDataModelNoZ][#-- DataModel for &pinctrl node --]
	[#assign dtPinCtrlDataModelZ = dt.dtPinCtrlDataModelZ][#-- DataModel for &pinctrl_z node --]

	[#assign ipInstanceListExtraNodeNoZ = dt.ipInstanceListExtraNodeNoZ][#-- List of pinCtrl nodes for &pinctrl --]
	[#assign ipInstanceListExtraNodeZ = dt.ipInstanceListExtraNodeZ][#-- List of pinCtrl nodes for &pinctrl with extra nodes --]
	[#assign ipInstanceListNoZ = dt.ipInstanceListNoZ][#-- List of pinCtrl nodes for &pinctrl_z --]
	[#assign ipInstanceListZ = dt.ipInstanceListZ][#-- List of pinCtrl nodes for &pinctrl_z with extra nodes --]

	[#assign ipPinCtrlNodesNoZ = dt.ipPinCtrlNodesNoZ][#-- map ipIstance -> pinCtrl nodes list for &pinctrl --]
	[#assign ipPinCtrlNodesZ = dt.ipPinCtrlNodesZ][#-- map ipIstance -> pinCtrl nodes list for &pinctrl_z --]

	[#assign pinCtrlBankZ = dt.pinCtrlBankZ][#-- boolean for specific &pinctrl_z handling --]

	[#assign GPIOMode = { "GPIO_MODE_AF_OD": "drive-open-drain", "GPIO_MODE_AF_PP": "drive-push-pull" }]
	[#assign GPIOPuPd = { "GPIO_NOPULL": "bias-disable", "GPIO_PULLUP": "bias-pull-up", "GPIO_PULLDOWN": "bias-pull-down" }]
	[#assign GPIOSpeed = { "GPIO_SPEED_FREQ_LOW": "slew-rate = <0>", "GPIO_SPEED_FREQ_MEDIUM": "slew-rate = <1>", "GPIO_SPEED_FREQ_HIGH": "slew-rate = <2>", "GPIO_SPEED_FREQ_VERY_HIGH": "slew-rate = <3>" }]

	[#assign T1 = "\t"][#-- 1 Tab --]
	[#assign T2 = "\t\t"][#-- 2 Tab --]
	[#assign T3 = "\t\t\t"][#-- 3 Tab --]
	[#assign T4 = "\t\t\t\t"][#-- 4 Tab --]
	[#assign T5 = "\t\t\t\t\t"][#-- 5 Tab --]

	[#--build nodes list to generate based on dtIODevicesList IPs list--]
	[#assign ipToGenerate = []]
	[#assign generateNode = true]
	[#assign generateNodeZ = true]
	[#list srvcmx_getListOfDevicesWithPinCtrl_inDTS() as ip]
		[#assign ipUpper = ip?upper_case ]
		[#if ipPinCtrlNodesNoZ.containsKey(ipUpper)]
			[#assign ipToGenerate = ipToGenerate + [ipUpper] ]
			[#assign generateNode = true]
		[/#if]
		[#if ipPinCtrlNodesZ.containsKey(ipUpper) && pinCtrlBankZ]
			[#assign ipToGenerate = ipToGenerate + [ipUpper] ]
			[#assign generateNodeZ = true]
		[/#if]
	[/#list]

	[#if srvcmx_isTargetedFw_inDTS("LINUX")][#--FW contextualization--]
		[#assign kernelDt = true ]
	[#else]
		[#assign kernelDt = false ]
	[/#if]

	[#if srvcmx_isTargetedFw_inDTS("U-BOOT")][#--FW contextualization--]
		[#assign uBootDt = true ]
	[#else]
		[#assign uBootDt = false ]
	[/#if]

[/#compress]
	[#if !uBootDt]
		[#if generateNode][#--to not generate empty nodes for atf DT & not pinCtrl for uBoot DT--]
&pinctrl {
			[#if kernelDt][#--no 'u-boot,dm-pre-reloc' tags for atf DT--]
${T1}u-boot,dm-pre-reloc;
#n
				[@pinctrlPrint dtPinCtrlDataModel=dtPinCtrlDataModelNoZ ipInstanceList=ipInstanceListExtraNodeNoZ bankZ=false/]
			[#else]
				[@pinctrlPrint dtPinCtrlDataModel=dtPinCtrlDataModelNoZ ipInstanceList=ipInstanceListNoZ bankZ=false/]
			[/#if]
${T1}/* USER CODE BEGIN pinctrl */
${T1}/* USER CODE END pinctrl */
};
		[/#if]
[#t]
		[#if pinCtrlBankZ]
			[#if generateNodeZ][#--to not generate empty nodes for atf DT & not pinCtrl for uBoot DT--]
#n
&pinctrl_z {
			[#if kernelDt][#--no 'u-boot,dm-pre-reloc' tags for atf DT--]
${T1}u-boot,dm-pre-reloc;
#n
				[@pinctrlPrint dtPinCtrlDataModel=dtPinCtrlDataModelZ ipInstanceList=ipInstanceListExtraNodeZ bankZ=true/]
			[#else]
				[@pinctrlPrint dtPinCtrlDataModel=dtPinCtrlDataModelZ ipInstanceList=ipInstanceListZ bankZ=true/]
			[/#if]
${T1}/* USER CODE BEGIN pinctrl_z */
${T1}/* USER CODE END pinctrl_z */
};
			[/#if]
		[/#if]
	[/#if]
[/#list]



[#function noContainsStr strlist str]
	[#list strlist as elem]
		[#if str = elem]
			[#return false]
		[/#if]
	[/#list]
	[#return true]
[/#function]



[#-- macro pinctrlPrint --]
[#macro pinctrlPrint dtPinCtrlDataModel ipInstanceList bankZ]
	[#list ipInstanceList as node][#-- For each pinCtrl node --]
[#compress]
		[#assign nodeLower = (node?lower_case) ]
		[#assign device = nodeLower?split("_")[0]]

		[#if srvcmx_getBootloadersEnabledDevicesList()?seq_contains(device) && kernelDt]
			[#assign ipBootTag = true ]
		[#else]
			[#assign ipBootTag = false ]
		[/#if]

		[#assign generateNode = false ]
		[#list ipToGenerate as ip]
			[#if node?starts_with(ip)]
				[#assign generateNode = true ]
				[#break]
			[/#if]
		[/#list]

[/#compress]
		[#if ((dtPinCtrlDataModel.get(node).entrySet()?size>0) && generateNode)][#-- --]
			[#if bankZ]
${T1}${nodeLower}_pins_z_mx: ${nodeLower}_mx-0 {[#--CMX generates only 1 config--]
			[#else]
${T1}${nodeLower}_pins_mx: ${nodeLower}_mx-0 {[#--CMX generates only 1 config--]
			[/#if]
			[#if ipBootTag]
${T2}u-boot,dm-pre-reloc;
			[/#if]
[#compress]

				[#assign gpioParam = {}]

				[#-- ############################## DataModel Processing ############################## --]
				[#-- # for each signal, the gpio config is encoded in gpioConfig in order to gather   # --]
				[#-- # pinmux with same gpio config for printing									  # --]
				[#list dtPinCtrlDataModel.get(node).entrySet() as gpioparamEntry][#--For all signals of the IP--]
					[#assign gpioConfig = ""]

					[#-- Retrieve key pin & pin mux config--]
					[#assign dtKey = gpioparamEntry.key][#-- ex: <STM32_PINMUX('A',6,ANALOG)>&/* ADC1_IN3 */ --]

					[#-- Save gpio configuration >> concatenated in gpioConfig --]

					[#--biasprop--]
					[#if gpioparamEntry.value.containsKey("GPIO_PuPd")]
						[#list GPIOPuPd?keys as key]
							[#if key == gpioparamEntry.value.get("GPIO_PuPd")]
								[#if gpioConfig == ""]
									[#assign gpioConfig = GPIOPuPd[key]]
								[#else]
									[#assign gpioConfig = gpioConfig+"&"+GPIOPuPd[key]]
								[/#if]
								[#break]
							[/#if]
						[/#list]
					[/#if]

					[#--biasprop--]
					[#if gpioparamEntry.value.containsKey("GPIO_PuPdOD")]
						[#list GPIOPuPd?keys as key]
							[#if key == gpioparamEntry.value.get("GPIO_PuPdOD")]
								[#if gpioConfig == ""]
									[#assign gpioConfig = GPIOPuPd[key]]
								[#else]
									[#assign gpioConfig = gpioConfig+"&"+GPIOPuPd[key]]
								[/#if]
								[#break]
							[/#if]
						[/#list]
					[/#if]

					[#--biasprop--]
					[#if gpioparamEntry.value.containsKey("GPIO_Pu")]
						[#list GPIOPuPd?keys as key]
							[#if key == gpioparamEntry.value.get("GPIO_Pu")]
								[#if gpioConfig == ""]
									[#assign gpioConfig = GPIOPuPd[key]]
								[#else]
									[#assign gpioConfig = gpioConfig+"&"+GPIOPuPd[key]]
								[/#if]
								[#break]
							[/#if]
						[/#list]
					[/#if]

					[#--driverprop--]
					[#list gpioparamEntry.value?keys as key1]
						[#if key1?starts_with("GPIO_Mode")]
							[#list GPIOMode?keys as key2]
								[#if key2 == gpioparamEntry.value.get(key1)]
									[#if gpioConfig == ""]
										[#assign gpioConfig = GPIOMode[key2]]
									[#else]
										[#assign gpioConfig = gpioConfig+"&"+GPIOMode[key2]]
									[/#if]
									[#break]
								[/#if]
							[/#list]
							[#break]
						[/#if]
					[/#list]

					[#--slew-rateprop--]
					[#list gpioparamEntry.value?keys as key1]
						[#if key1?starts_with("GPIO_Speed")]
							[#list GPIOSpeed?keys as key2]
								[#if key2 == gpioparamEntry.value.get(key1)]
									[#if gpioConfig == ""]
										[#assign gpioConfig = GPIOSpeed[key2]]
									[#else]
										[#assign gpioConfig = gpioConfig+"&"+GPIOSpeed[key2]]
									[/#if]
									[#break]
								[/#if]
							[/#list]
							[#break]
						[/#if]
					[/#list]

					[#assign gpioParam = gpioParam+{dtKey:gpioConfig}][#--gpioParam will contain the list of all "pinmux:gpioConfig" of the ip ex: <STM32_PINMUX('A',6,ANALOG)>:[gpioConfig]--]
				[/#list]

				[#-- check and save if pinmuxs with different config or no (multiConfig flag) --]
				[#assign firstLoop = true]
				[#assign multiConfig = false]
				[#assign monoConfig = ""]
				[#list gpioParam?values as config]
					[#if firstLoop]
						[#assign monoConfig = config]
						[#assign firstLoop = false]
					[#elseif monoConfig != config]
						[#assign multiConfig = true]
						[#break]
					[/#if]
				 [/#list]

[/#compress]
				[#-- ################################ pinCtrl Printing ############################# --]
				[#-- # pinmux are printed gathering the same gpio config						   # --]
				[#if multiConfig][#-- if pinmuxs with different gpio configs --]
					[#assign index = 1]
					[#assign signalDone = []]
					[#list gpioParam?keys?sort as pinMux][#--for all pinMux (ex: <STM32_PINMUX('A',6,ANALOG)>)
															 NB: key sorting is mandatory--]
							[#if noContainsStr(signalDone, pinMux)][#--signalDone records pinMux already traited for the ip--]
								[#assign config = gpioParam[pinMux]]
[#t]
								[#assign signalsSameConfig = []]
								[#assign signalsSameConfigSortedTemp = []]
								[#assign signalsSameConfigSorted = []]
								[#assign ls1 = []]
								[#assign ls2 = []]
[#t]
${T2}pins${index} {
									[#if ipBootTag]
${T3}u-boot,dm-pre-reloc;
									[/#if]
									[#-- ########### find pinMuxs with same config ########## --]
									[#assign index = index+1]
[#t]
									[#assign signalDone = signalDone + [pinMux]]
									[#assign signalsSameConfig = signalsSameConfig + [pinMux]]
[#t]
									[#list gpioParam?keys?sort as pinMux2][#-- find pinMuxs with same config
																				NB: key sorting is mandatory--]
										[#if noContainsStr(signalDone, pinMux2) && (gpioParam[pinMux2] == config)]
											[#assign signalDone = signalDone + [pinMux2]][#-- save pinMux already traited --]
											[#assign signalsSameConfig = signalsSameConfig + [pinMux2]][#-- save pinMux with same config --]
										[/#if]
									[/#list]
[#t]
									[#-- ########### print pinMux with same config (saved in signalsSameConfig) ########### --]
									[#assign savedPinMux = ""]
									[#assign savedEntry = ""]
[#t]
									[#--sort pinMuxs for printing (port letter + number)--]
									[#list signalsSameConfig as entry]
										[#assign savedEntry = entry]
										[#assign ls1 = ls1 + [{"port":entry?split(",")[0], "nb":entry?split(",")[1]?trim?number, "pinMux":savedEntry}]]
									[/#list]
									[#list ls1?sort_by(["nb"]) as entry]
										[#assign ls2 = ls2 + [entry]]
									[/#list]
									[#list ls2?sort_by(["port"]) as entry]
										[#assign signalsSameConfigSortedTemp = signalsSameConfigSortedTemp + [entry.pinMux]]
									[/#list]
									[#list signalsSameConfigSortedTemp as entry][#--remove duplicates--]
										[#if entry?split("/")[0] != savedPinMux?split("/")[0]]
											[#assign signalsSameConfigSorted = signalsSameConfigSorted + [entry]]
										[/#if]
										[#assign savedPinMux = entry]
									[/#list]
[#t]
									[#-- print pinMux with same config --]
									[#assign sizeSame = signalsSameConfigSorted?size]
									[#list signalsSameConfigSorted as pinMux]
										[#if signalsSameConfigSorted?seq_index_of(pinMux) == 0]
											[#if sizeSame == 1]
${T3}pinmux = ${pinMux?split("&")[0]}; ${pinMux?split("&")[1]}
											[#else]
${T3}pinmux = ${pinMux?split("&")[0]}, ${pinMux?split("&")[1]}
											[/#if]
										[#else]
											[#if signalsSameConfigSorted?seq_index_of(pinMux) == (sizeSame-1)]
${T5} ${pinMux?split("&")[0]}; ${pinMux?split("&")[1]}
											[#else]
${T5} ${pinMux?split("&")[0]}, ${pinMux?split("&")[1]}
											[/#if]
										[/#if]
									[/#list]
[#t]
									[#--gpios configuration--]
									[#if config != ""]
										[#list config?split("&") as conf]
${T3}${conf};
										[/#list]
									[/#if]
${T2}};
							[/#if]
					[/#list]
				[#else][#-- if all IP pinmuxs with same gpio config --]
[#t]
					[#assign signals = []]
					[#assign signalsSortedTemp = []]
					[#assign signalsSorted = []]
					[#assign ls1 = []]
					[#assign ls2 = []]
[#t]
					[#list gpioParam?keys?sort as pinMux][#--for all pinMux (ex: <STM32_PINMUX('A',6,ANALOG)>)
															NB: key sorting in case of--]
						[#assign signals = signals + [pinMux]]
					[/#list]
[#t]
					[#-- ########### print pinMuxs ########### --]
					[#assign savedPinMux = ""]
					[#assign savedEntry = ""]
[#t]
					[#--sort pinMuxs for printing (port letter + number)--]
					[#list signals as entry]
						[#assign savedEntry = entry]
						[#assign ls1 = ls1 + [{"port":entry?split(",")[0], "nb":entry?split(",")[1]?trim?number, "pinMux":savedEntry}]]
					[/#list]
					[#list ls1?sort_by(["nb"]) as entry]
						[#assign ls2 = ls2 + [entry]]
					[/#list]
					[#list ls2?sort_by(["port"]) as entry]
						[#assign signalsSortedTemp = signalsSortedTemp + [entry.pinMux]]
					[/#list]
					[#list signalsSortedTemp as entry][#--remove duplicates--]
						[#if entry?split("/")[0] != savedPinMux?split("/")[0]]
							[#assign signalsSorted = signalsSorted + [entry]]
						[/#if]
						[#assign savedPinMux = entry]
					[/#list]
[#t]
					[#-- print pinMux --]
					[#assign size = signalsSorted?size]
${T2}pins {
						[#if ipBootTag]
${T3}u-boot,dm-pre-reloc;
						[/#if]
						[#list signalsSorted as pinMux]
							[#if signalsSorted?seq_index_of(pinMux) == 0]
								[#if size == 1]
${T3}pinmux = ${pinMux?split("&")[0]}; ${pinMux?split("&")[1]}
								[#else]
${T3}pinmux = ${pinMux?split("&")[0]}, ${pinMux?split("&")[1]}
								[/#if]
							[#else]
								[#if signalsSorted?seq_index_of(pinMux) == (size-1)]
${T5} ${pinMux?split("&")[0]}; ${pinMux?split("&")[1]}
								[#else]
${T5} ${pinMux?split("&")[0]}, ${pinMux?split("&")[1]}
								[/#if]
							[/#if]
						[/#list]
[#t]
						[#--gpios configuration--]
						[#if monoConfig != ""]
							[#list monoConfig?split("&") as conf]
${T3}${conf};
							[/#list]
						[/#if]
${T2}};
				[/#if][#-- multiConfig --]
${T1}};
#n
		[/#if][#--  --]
	[/#list][#-- eof list usedIPs --]
[/#macro]
[#-- End macro pinctrlPrint --]
