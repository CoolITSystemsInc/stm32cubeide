[#ftl]
/**
  ******************************************************************************
  * @file    radio_board_if.c
  * @author  MCD Application Team
  * @brief   This file provides an interface layer between MW and Radio Board
  ******************************************************************************
[@common.optinclude name=mxTmpFolder+ "/license.tmp"/][#--include License text --]
  ******************************************************************************
  */
[#assign useBsp=false]
[#assign myBoardName=""]
[#--
********************************
BSP IP Datas:

[#if BspIpDatas??]
  [#list BspIpDatas as SWIP]
    [#if SWIP.defines??]
Defines:
      [#list SWIP.defines as defines]
        ${defines.name}: ${defines.value}
      [/#list]
    [/#if]
    [#if SWIP.variables??]
Variables:
      [#list SWIP.variables as variables]
        ${variables.name}: ${variables.value}
      [/#list]
    [/#if]
  [/#list]
[/#if]

********************************
SWIP Datas:

[#if SWIPdatas??]
  [#list SWIPdatas as SWIP]
    [#if SWIP.defines??]
Defines:
      [#list SWIP.defines as definition]
        ${definition.name}: ${definition.value}
      [/#list]
    [/#if]
  [/#list]
[/#if]
********************************
--]
[#if SWIPdatas??]
  [#list SWIPdatas as SWIP]
    [#if SWIP.defines??]
      [#list SWIP.defines as definition]
        [#assign value = definition.value]
          [#if definition.name == "Activate_RADIO_BOARD_INTERFACE"]
          [#if value == "true"]
            [#assign useBsp=true]
            [#if Board_RPN??]
              [#assign myBoardName=Board_RPN?upper_case?replace("-","_")]
            [/#if]
          [/#if]
        [/#if]
      [/#list]
    [/#if]
  [/#list]
[#else]
  [#assign useBsp=true]
  [#if Board_RPN??]
    [#assign myBoardName=Board_RPN?upper_case?replace("-","_")]
  [/#if]
[/#if]
/* Includes ------------------------------------------------------------------*/
#include "radio_board_if.h"

/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* External variables ---------------------------------------------------------*/
/* USER CODE BEGIN EV */

/* USER CODE END EV */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
/* USER CODE BEGIN PV */

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Exported functions --------------------------------------------------------*/
int32_t RBI_Init(void)
{
  /* USER CODE BEGIN RBI_Init_1 */

  /* USER CODE END RBI_Init_1 */
[#-- RBI INIT FOR BSP DRIVER --]
#if defined(USE_BSP_DRIVER)
  /* code generated by MX does not support BSP */
  /* In order to use BSP driver, add the correspondent files in the IDE workspace */
  /* and define USE_BSP_DRIVER in the preprocessor definitions  or in platform.h */
  return BSP_RADIO_Init();
[#if useBsp]
#elif defined(MX_${myBoardName})
  /* should be calling BSP_RADIO_Init() but not supported by MX*/

  GPIO_InitTypeDef  gpio_init_structure = {0};

  /* Enable the Radio Switch Clock */
  RF_SW_CTRL3_GPIO_CLK_ENABLE();

  /* Configure the Radio Switch pin */
  gpio_init_structure.Pin   = RF_SW_CTRL1_PIN;
  gpio_init_structure.Mode  = GPIO_MODE_OUTPUT_PP;
  gpio_init_structure.Pull  = GPIO_NOPULL;
  gpio_init_structure.Speed = GPIO_SPEED_FREQ_VERY_HIGH;

  HAL_GPIO_Init(RF_SW_CTRL1_GPIO_PORT, &gpio_init_structure);

  gpio_init_structure.Pin = RF_SW_CTRL2_PIN;
  HAL_GPIO_Init(RF_SW_CTRL2_GPIO_PORT, &gpio_init_structure);

  gpio_init_structure.Pin = RF_SW_CTRL3_PIN;
  HAL_GPIO_Init(RF_SW_CTRL3_GPIO_PORT, &gpio_init_structure);

  HAL_GPIO_WritePin(RF_SW_CTRL2_GPIO_PORT, RF_SW_CTRL2_PIN, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(RF_SW_CTRL1_GPIO_PORT, RF_SW_CTRL1_PIN, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(RF_SW_CTRL3_GPIO_PORT, RF_SW_CTRL3_PIN, GPIO_PIN_RESET);

  return 0;
[/#if]
#else
  /* USER CODE BEGIN RBI_Init_2 */
#error user to provide its board code or to call his board driver functions
  /* USER CODE END RBI_Init_2 */
#endif  /* USE_BSP_DRIVER [#if useBsp] || MX_${myBoardName} [/#if] */
  /* USER CODE BEGIN RBI_Init_3 */

  /* USER CODE END RBI_Init_3 */
}

int32_t RBI_DeInit(void)
{
  /* USER CODE BEGIN RBI_DeInit_1 */

  /* USER CODE END RBI_DeInit_1 */
#if defined(USE_BSP_DRIVER)
  /* code generated by MX does not support BSP */
  /* In order to use BSP driver, add the correspondent files in the IDE workspace */
  /* and define USE_BSP_DRIVER in the preprocessor definitions  or in platform.h */
  return BSP_RADIO_DeInit();
[#if useBsp]
#elif defined(MX_${myBoardName})
  RF_SW_CTRL3_GPIO_CLK_ENABLE();

  /* Turn off switch */
  HAL_GPIO_WritePin(RF_SW_CTRL1_GPIO_PORT, RF_SW_CTRL1_PIN, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(RF_SW_CTRL2_GPIO_PORT, RF_SW_CTRL2_PIN, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(RF_SW_CTRL3_GPIO_PORT, RF_SW_CTRL3_PIN, GPIO_PIN_RESET);

  /* DeInit the Radio Switch pin */
  HAL_GPIO_DeInit(RF_SW_CTRL1_GPIO_PORT, RF_SW_CTRL1_PIN);
  HAL_GPIO_DeInit(RF_SW_CTRL2_GPIO_PORT, RF_SW_CTRL2_PIN);
  HAL_GPIO_DeInit(RF_SW_CTRL3_GPIO_PORT, RF_SW_CTRL3_PIN);

  return 0;
[/#if]
#else
  /* USER CODE BEGIN RBI_DeInit_2 */
#error user to provide its board code or to call his board driver functions
  /* USER CODE END RBI_DeInit_2 */
#endif  /* USE_BSP_DRIVER [#if useBsp] || MX_${myBoardName} [/#if]*/
  /* USER CODE BEGIN RBI_DeInit_3 */

  /* USER CODE END RBI_DeInit_3 */
}

int32_t RBI_ConfigRFSwitch(RBI_Switch_TypeDef Config)
{
  /* USER CODE BEGIN RBI_ConfigRFSwitch_1 */

  /* USER CODE END RBI_ConfigRFSwitch_1 */
#if defined(USE_BSP_DRIVER)
  /* code generated by MX does not support BSP */
  /* In order to use BSP driver, add the correspondent files in the IDE workspace */
  /* and define USE_BSP_DRIVER in the preprocessor definitions  or in platform.h */
  return BSP_RADIO_ConfigRFSwitch((BSP_RADIO_Switch_TypeDef) Config);
[#if useBsp]
#elif defined(MX_${myBoardName})
  switch (Config)
  {
    case RBI_SWITCH_OFF:
    {
      /* Turn off switch */
      HAL_GPIO_WritePin(RF_SW_CTRL3_GPIO_PORT, RF_SW_CTRL3_PIN, GPIO_PIN_RESET);
      HAL_GPIO_WritePin(RF_SW_CTRL1_GPIO_PORT, RF_SW_CTRL1_PIN, GPIO_PIN_RESET);
      HAL_GPIO_WritePin(RF_SW_CTRL2_GPIO_PORT, RF_SW_CTRL2_PIN, GPIO_PIN_RESET);
      break;
    }
    case RBI_SWITCH_RX:
    {
      /*Turns On in Rx Mode the RF Switch */
      HAL_GPIO_WritePin(RF_SW_CTRL3_GPIO_PORT, RF_SW_CTRL3_PIN, GPIO_PIN_SET);
      HAL_GPIO_WritePin(RF_SW_CTRL1_GPIO_PORT, RF_SW_CTRL1_PIN, GPIO_PIN_SET);
      HAL_GPIO_WritePin(RF_SW_CTRL2_GPIO_PORT, RF_SW_CTRL2_PIN, GPIO_PIN_RESET);
      break;
    }
    case RBI_SWITCH_RFO_LP:
    {
      /*Turns On in Tx Low Power the RF Switch */
      HAL_GPIO_WritePin(RF_SW_CTRL3_GPIO_PORT, RF_SW_CTRL3_PIN, GPIO_PIN_SET);
      HAL_GPIO_WritePin(RF_SW_CTRL1_GPIO_PORT, RF_SW_CTRL1_PIN, GPIO_PIN_SET);
      HAL_GPIO_WritePin(RF_SW_CTRL2_GPIO_PORT, RF_SW_CTRL2_PIN, GPIO_PIN_SET);
      break;
    }
    case RBI_SWITCH_RFO_HP:
    {
      /*Turns On in Tx High Power the RF Switch */
      HAL_GPIO_WritePin(RF_SW_CTRL3_GPIO_PORT, RF_SW_CTRL3_PIN, GPIO_PIN_SET);
      HAL_GPIO_WritePin(RF_SW_CTRL1_GPIO_PORT, RF_SW_CTRL1_PIN, GPIO_PIN_RESET);
      HAL_GPIO_WritePin(RF_SW_CTRL2_GPIO_PORT, RF_SW_CTRL2_PIN, GPIO_PIN_SET);
      break;
    }
    default:
      break;
  }

  return 0;
[/#if]
#else
  /* USER CODE BEGIN RBI_ConfigRFSwitch_2 */
#error user to provide its board code or to call his board driver functions
  /* USER CODE END RBI_ConfigRFSwitch_2 */
#endif  /* USE_BSP_DRIVER [#if useBsp] || MX_${myBoardName} [/#if]*/
  /* USER CODE BEGIN RBI_ConfigRFSwitch_3 */

  /* USER CODE END RBI_ConfigRFSwitch_3 */
}

int32_t RBI_GetTxConfig(void)
{
  /* USER CODE BEGIN RBI_GetTxConfig_1 */

  /* USER CODE END RBI_GetTxConfig_1 */
#if defined(USE_BSP_DRIVER)
  /* code generated by MX does not support BSP */
  /* In order to use BSP driver, add the correspondent files in the IDE workspace */
  /* and define USE_BSP_DRIVER in the preprocessor definitions  or in platform.h */
  return BSP_RADIO_GetTxConfig();

[#if useBsp]
#elif defined(MX_${myBoardName})
  return RBI_CONF_RFO;
[/#if]
#else
  /* USER CODE BEGIN RBI_GetTxConfig_2 */
#error user to provide its board code or to call his board driver functions
  /* USER CODE END RBI_GetTxConfig_2 */
#endif  /* USE_BSP_DRIVER [#if useBsp] || MX_${myBoardName} [/#if]*/
  /* USER CODE BEGIN RBI_GetTxConfig_3 */

  /* USER CODE END RBI_GetTxConfig_3 */
}

int32_t RBI_GetWakeUpTime(void)
{
  /* USER CODE BEGIN RBI_GetWakeUpTime_1 */

  /* USER CODE END RBI_GetWakeUpTime_1 */
#if defined(USE_BSP_DRIVER)
  /* code generated by MX does not support BSP */
  /* In order to use BSP driver, add the correspondent files in the IDE workspace */
  /* and define USE_BSP_DRIVER in the preprocessor definitions  or in platform.h */
  return  BSP_RADIO_GetWakeUpTime();

[#if useBsp]
#elif defined(MX_${myBoardName})
  return RF_WAKEUP_TIME;
[/#if]
#else
  /* USER CODE BEGIN RBI_GetWakeUpTime_2 */
#error user to provide its board code or to call his board driver functions
  /* USER CODE END RBI_GetWakeUpTime_2 */
#endif  /* USE_BSP_DRIVER [#if useBsp] || MX_${myBoardName} [/#if]*/
  /* USER CODE BEGIN RBI_GetWakeUpTime_3 */

  /* USER CODE END RBI_GetWakeUpTime_3 */
}

int32_t RBI_IsTCXO(void)
{
  /* USER CODE BEGIN RBI_IsTCXO_1 */

  /* USER CODE END RBI_IsTCXO_1 */
#if defined(USE_BSP_DRIVER)
  /* code generated by MX does not support BSP */
  /* In order to use BSP driver, add the correspondent files in the IDE workspace */
  /* and define USE_BSP_DRIVER in the preprocessor definitions  or in platform.h */
  return BSP_RADIO_IsTCXO();

[#if useBsp]
#elif defined(MX_${myBoardName})
  return IS_TCXO_SUPPORTED;
[/#if]
#else
  /* USER CODE BEGIN RBI_IsTCXO_2 */
#error user to provide its board code or to call his board driver functions
  /* USER CODE END RBI_IsTCXO_2 */
#endif  /* USE_BSP_DRIVER  [#if useBsp] || MX_${myBoardName} [/#if]*/
  /* USER CODE BEGIN RBI_IsTCXO_3 */

  /* USER CODE END RBI_IsTCXO_3 */
}

int32_t RBI_IsDCDC(void)
{
  /* USER CODE BEGIN RBI_IsDCDC_1 */

  /* USER CODE END RBI_IsDCDC_1 */
#if defined(USE_BSP_DRIVER)
  /* code generated by MX does not support BSP */
  /* In order to use BSP driver, add the correspondent files in the IDE workspace */
  /* and define USE_BSP_DRIVER in the preprocessor definitions  or in platform.h */
  return BSP_RADIO_IsDCDC();

[#if useBsp]
#elif defined(MX_${myBoardName})
[/#if]
  return IS_DCDC_SUPPORTED;
#else
  /* USER CODE BEGIN RBI_IsDCDC_2 */
#error user to provide its board code or to call his board driver functions
  /* USER CODE END RBI_IsDCDC_2 */
#endif  /* USE_BSP_DRIVER  [#if useBsp] || MX_${myBoardName} [/#if]*/
  /* USER CODE BEGIN RBI_IsDCDC_3 */

  /* USER CODE END RBI_IsDCDC_3 */
}

/* USER CODE BEGIN EF */

/* USER CODE END EF */

/* Private Functions Definition -----------------------------------------------*/
/* USER CODE BEGIN PrFD */

/* USER CODE END PrFD */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
