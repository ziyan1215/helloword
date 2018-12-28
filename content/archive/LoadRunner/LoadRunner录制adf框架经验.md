---
title: "LoadRunner录制adf框架经验"
tags: [LoadRunner]
slug: 1545987858
keywords: [LoadRunner]
date: 2018-12-28 17:04:18
---

# 配置关联规则
用LoadRunner11录制ADF框架系统是，回放会报错，因为adf框架的原因，录制时要加入关联脚本
```xml
<?xml version="1.0"?>
<CorrelationSettings>
   <Group Name="Oracle ADF" Enable="1" Icon="logo_default.bmp">
      <Rule Name="adf.ctrl-state" LeftBoundText="_adf.ctrl-state=" LeftBoundType="1" LeftBoundInstance="0" RightBoundText="&quot;" RightBoundType="1" AltRightBoundText="Newline Character" AltRightBoundType="4" Flags="137" ParamPrefix="adf.ctrl-state" Type="8" SaveOffset="0" SaveLen="-1" CallbackName="" CallbackDLLName="" FormField="" ReplaceLB="" ReplaceRB="" />
      <Rule Name="adf.winId" LeftBoundText="_adf.winId=" LeftBoundType="1" LeftBoundInstance="0" RightBoundText="&amp;" RightBoundType="1" AltRightBoundText="" AltRightBoundType="1" Flags="137" ParamPrefix="adf.winId" Type="8" SaveOffset="0" SaveLen="-1" CallbackName="" CallbackDLLName="" FormField="" ReplaceLB="" ReplaceRB="" />
      <Rule Name="jsessionid" LeftBoundText="jsessionid=" LeftBoundType="1" LeftBoundInstance="0" RightBoundText="&quot;" RightBoundType="1" AltRightBoundText="" AltRightBoundType="1" Flags="136" ParamPrefix="jsessionid" Type="8" SaveOffset="0" SaveLen="-1" CallbackName="" CallbackDLLName="" FormField="" ReplaceLB="" ReplaceRB="" />
      <Rule Name="STATETOKEN" LeftBoundText="javax.faces.ViewState&quot; value=&quot;" LeftBoundType="1" LeftBoundInstance="0" RightBoundText="&quot;&gt;" RightBoundType="1" AltRightBoundText="" AltRightBoundType="1" Flags="136" ParamPrefix="STATETOKEN" Type="8" SaveOffset="0" SaveLen="-1" CallbackName="" CallbackDLLName="" FormField="" ReplaceLB="" ReplaceRB="" />
      <Rule Name="afrLoop" LeftBoundText="_afrLoop=" LeftBoundType="1" LeftBoundInstance="0" RightBoundText="&quot;" RightBoundType="1" AltRightBoundText="" AltRightBoundType="1" Flags="136" ParamPrefix="afrLoop" Type="8" SaveOffset="0" SaveLen="-1" CallbackName="" CallbackDLLName="" FormField="" ReplaceLB="" ReplaceRB="" />
      <Rule Name="adf.ctrl-state_new" LeftBoundText="_adf.ctrl-state=" LeftBoundType="1" LeftBoundInstance="0" RightBoundText="&lt;" RightBoundType="1" AltRightBoundText="" AltRightBoundType="1" Flags="9" ParamPrefix="adf.ctrl-state_new" Type="8" SaveOffset="0" SaveLen="-1" CallbackName="" CallbackDLLName="" FormField="" ReplaceLB="" ReplaceRB="" />
      <Rule Name="SecurityUsersCreateUserPortletfrsc" LeftBoundText="SecurityUsersCreateUserPortletfrsc&quot; value=&quot;" LeftBoundType="1" LeftBoundInstance="0" RightBoundText="&quot;&gt;" RightBoundType="1" AltRightBoundText="" AltRightBoundType="1" Flags="8" ParamPrefix="SecurityUsersCreateUserPortletfrsc" Type="8" SaveOffset="0" SaveLen="-1" CallbackName="" CallbackDLLName="" FormField="" ReplaceLB="" ReplaceRB="" />
      <Rule Name="CreatedPageName" LeftBoundText="/Page" LeftBoundType="1" LeftBoundInstance="0" RightBoundText=".jspx" RightBoundType="1" AltRightBoundText="" AltRightBoundType="1" Flags="1037" ParamPrefix="createPageName" Type="8" SaveOffset="0" SaveLen="-1" CallbackName="" CallbackDLLName="" FormField="" ReplaceLB="" ReplaceRB="" />
      <Rule Name="adfp_rendition_cahce_key" LeftBoundText="_adfp_rendition_cahce_key=" LeftBoundType="1" LeftBoundInstance="0" RightBoundText="&amp;" RightBoundType="1" AltRightBoundText="" AltRightBoundType="1" Flags="8" ParamPrefix="adfp_rendition_cahce_key" Type="8" SaveOffset="0" SaveLen="-1" CallbackName="" CallbackDLLName="" FormField="" ReplaceLB="" ReplaceRB="" />
      <Rule Name="adfp_request_hash" LeftBoundText="_adfp_request_hash=" LeftBoundType="1" LeftBoundInstance="0" RightBoundText="&quot;" RightBoundType="1" AltRightBoundText="" AltRightBoundType="1" Flags="8" ParamPrefix="adfp_request_hash" Type="8" SaveOffset="0" SaveLen="-1" CallbackName="" CallbackDLLName="" FormField="" ReplaceLB="" ReplaceRB="" />
      <Rule Name="adfp_full_page_mode_request" LeftBoundText="_adfp_full_page_mode_request%3D" LeftBoundType="1" LeftBoundInstance="0" RightBoundText="%" RightBoundType="1" AltRightBoundText="" AltRightBoundType="1" Flags="8" ParamPrefix="adfp_full_page_mode_request" Type="8" SaveOffset="0" SaveLen="-1" CallbackName="" CallbackDLLName="" FormField="" ReplaceLB="" ReplaceRB="" />
      <Rule Name="adfp_full_page_mode_request2" LeftBoundText="_adfp_full_page_mode_request=" LeftBoundType="1" LeftBoundInstance="0" RightBoundText="&amp;" RightBoundType="1" AltRightBoundText="" AltRightBoundType="1" Flags="8" ParamPrefix="adfp_full_page_mode_request2" Type="8" SaveOffset="0" SaveLen="-1" CallbackName="" CallbackDLLName="" FormField="" ReplaceLB="" ReplaceRB="" />
      <Rule Name="afrLoop2" LeftBoundText="_afrLoop=" LeftBoundType="1" LeftBoundInstance="0" RightBoundText="&lt;" RightBoundType="1" AltRightBoundText="" AltRightBoundType="1" Flags="8" ParamPrefix="afrLoop2" Type="8" SaveOffset="0" SaveLen="-1" CallbackName="" CallbackDLLName="" FormField="" ReplaceLB="" ReplaceRB="" />
      <Rule Name="afrLoop3" LeftBoundText="_afrLoop=" LeftBoundType="1" LeftBoundInstance="0" RightBoundText="&amp;" RightBoundType="1" AltRightBoundText="" AltRightBoundType="1" Flags="136" ParamPrefix="afrLoop3" Type="8" SaveOffset="0" SaveLen="-1" CallbackName="" CallbackDLLName="" FormField="" ReplaceLB="" ReplaceRB="" />
      <Rule Name="wsrp-resourceState" LeftBoundText="wsrp-resourceState~25253D" LeftBoundType="1" LeftBoundInstance="0" RightBoundText="~252526" RightBoundType="1" AltRightBoundText="" AltRightBoundType="1" Flags="8" ParamPrefix="wsrp-resourceState" Type="8" SaveOffset="0" SaveLen="-1" CallbackName="" CallbackDLLName="" FormField="" ReplaceLB="" ReplaceRB="" />
      <Rule Name="_afrWindowMode_checksum" LeftBoundText="_afrWindowMode~253D0~26checksum~3D" LeftBoundType="1" LeftBoundInstance="0" RightBoundText="/container-view" RightBoundType="1" AltRightBoundText="" AltRightBoundType="1" Flags="8" ParamPrefix="_afrWindowMode_checksum" Type="8" SaveOffset="0" SaveLen="-1" CallbackName="" CallbackDLLName="" FormField="" ReplaceLB="" ReplaceRB="" />
   </Group>
</CorrelationSettings>
```