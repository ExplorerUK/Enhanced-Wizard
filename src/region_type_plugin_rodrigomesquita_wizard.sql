prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_180100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2018.04.04'
,p_release=>'18.1.0.00.45'
,p_default_workspace_id=>1662011781335193
,p_default_application_id=>821
,p_default_owner=>'MDB_SCHEMA'
);
end;
/
prompt --application/shared_components/plugins/region_type/rodrigomesquita_wizard
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(81388577542511046)
,p_plugin_type=>'REGION TYPE'
,p_name=>'RODRIGOMESQUITA.WIZARD'
,p_display_name=>'Enhanced Wizard'
,p_supported_ui_types=>'DESKTOP'
,p_css_file_urls=>'#PLUGIN_FILES#enhancedwizard-min.css'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function get_page_num(link in varchar2)',
'    return number',
'    is',
'      ln_page_num number;',
'    BEGIN',
'    SELECT val',
'      INTO ln_page_num',
'    FROM (Select rownum AS rn, column_value AS val',
'         FROM TABLE(apex_string.split(link,'':'')))',
'    WHERE rn = 2;',
'    return ln_page_num;',
'    end;',
'    ',
'function render (',
'    p_region              in apex_plugin.t_region,',
'    p_plugin              in apex_plugin.t_plugin,',
'    p_is_printer_friendly in boolean )',
'    return apex_plugin.t_region_render_result',
'IS',
'    c_region_name         constant VARCHAR2(255) := p_region.name;',
'    c_region_id           constant VARCHAR2(255) := p_region.id;',
'    l_data_type_list      apex_application_global.vc_arr2;',
'    l_column_value_list   apex_plugin_util.t_column_value_list2;',
'    l_onload_code         VARCHAR2(32767);',
'    l_return apex_plugin.t_region_render_result;',
'    ln_first_list_sequence number;',
'    ln_current_page     number := 0;',
'    ln_past_page        number := 0;',
'    ln_last_sequence    number := 0;',
'    ln_current_sequence number := 0;',
'    l_url               varchar2(2000);',
'    l_app               number := v(''APP_ID'');',
'    l_session           number := v(''APP_SESSION'');',
'    lb_is_current       boolean := FALSE;',
'    lv_icon             varchar2(1000);',
'    lv_background       varchar2(1000);',
'    lv_icon_css         varchar2(1000);',
'    ',
'',
'BEGIN',
'htp.p(''<h2 class="u-VisuallyHidden">Current Progress</h2>'');',
'htp.p(''<ul class="t-WizardSteps " id="''||c_region_id||''">'');',
'',
'FOR i in (SELECT entry_attribute_01 icon,',
'                 display_sequence,',
'                 entry_text,',
'                 entry_target,',
'                 list_entry_id ',
'            FROM apex_application_list_entries le,',
'                 apex_workspaces aw ',
'           WHERE aw.workspace      = le.workspace ',
'             AND aw.workspace_id   = :WORKSPACE_ID ',
'             AND le.application_id = :APP_ID ',
'             AND le.list_name      = p_region.attribute_01',
'        ORDER BY le.display_sequence asc)',
'LOOP',
'   ln_current_page := get_page_num(i.ENTRY_TARGET);',
'   lv_icon := '''';',
'   lv_background := '''';',
'   if ln_current_page = :APP_PAGE_ID then',
'      lb_is_current := TRUE;',
'      ln_current_sequence := i.display_sequence;',
'   Else   ',
'      lb_is_current := FALSE;',
'   End If;  ',
'   If p_region.attribute_03 = ''Y'' Then',
'      If lb_is_current Then',
'         lv_icon_css := '' rmwiz-active-icon'';',
'      else',
'         lv_icon_css := '' rmwiz-next-icon'';',
'      end if;   ',
'      lv_icon := ''<span class="t-Icon fa ''||i.icon||lv_icon_css||''"></span>'';',
'      lv_background := ''rmwiz-icon-background'';',
'   End If;   ',
'   ',
'   l_url := APEX_UTIL.PREPARE_URL(p_url => ''f?p='' || l_app || '':''||ln_current_page||'':''||l_session||''::NO:::'',p_checksum_type => ''SESSION'');',
'',
'   if lb_is_current Then',
'      htp.p(''<li class="t-WizardSteps-step is-active" id="L''||i.list_entry_id||''">'');',
'      htp.p(''<div class="t-WizardSteps-wrap"><span class="t-WizardSteps-marker ''||lv_background||''">''||lv_icon||''</span><span class="t-WizardSteps-label">''); ',
'      htp.p(i.entry_text||'' <span class="t-WizardSteps-labelState">(Active)</span></span></div></li>'');',
'   elsif  (i.display_sequence > ln_last_sequence and ln_current_sequence = 0) Then',
'      htp.p('' <li class="t-WizardSteps-step is-complete" id="L''||i.list_entry_id||''">'');',
'      htp.p(''<div class="t-WizardSteps-wrap"><span class="t-WizardSteps-marker"><span class="t-Icon a-Icon icon-check"></span></span><span class="t-WizardSteps-label">'');',
'               if p_region.attribute_02 = ''Y'' Then',
'                  htp.p(''<a href="''||l_url||''">''||i.entry_text||''</a>'');',
'               else',
'                  htp.p(i.entry_text);',
'               end if;   ',
'   else',
'      htp.p(''<li class="t-WizardSteps-step is-active" id="L''||i.list_entry_id||''">'');',
'      htp.p(''<div class="t-WizardSteps-wrap"><span class="t-WizardSteps-marker ''||lv_background||''">''||lv_icon||''</span></span><span class="t-WizardSteps-label">''); ',
'            if p_region.attribute_02 = ''Y'' Then',
'               htp.p(''<a href="''||l_url||''">''||i.entry_text||''</a>'');',
'            else',
'               htp.p(i.entry_text);',
'            end if;',
'     htp.p(''<span class="t-WizardSteps-labelState">(Completed)</span></span></div></li>''); ',
'   End if;        ',
'   ln_last_sequence := i.display_sequence;',
'END LOOP;',
'',
'htp.p(''</ul><div class="u-Table-fit t-Wizard-buttons"></div>'');',
'',
'    RETURN l_return;',
'END;',
'',
''))
,p_api_version=>2
,p_render_function=>'render'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'  The plugin add new features to the APEX Wizard region.',
'</p>',
'<p>',
'  Author: <code>Rodrigo Mesquita</code><br/>',
'  E-mail: <code>rodrigo.mesquita@explorer.uk.com</code><br/>',
'  Twitter: <code>@mesquitarod</code><br/>',
'  Plugin home page: <code>https://github.com/ExplorerUK/Enhanced-Wizard</code>',
'  License: Licensed under the MIT (LICENSE.txt) license.',
'</p>'))
,p_version_identifier=>'1.0'
,p_about_url=>'https://github.com/ExplorerUK/Enhanced-Wizard'
,p_files_version=>6
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(81388818875514288)
,p_plugin_id=>wwv_flow_api.id(81388577542511046)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'List Name'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(81389047751518983)
,p_plugin_id=>wwv_flow_api.id(81388577542511046)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Show links'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(81389398770521841)
,p_plugin_id=>wwv_flow_api.id(81388577542511046)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Show Custom Icons'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_is_translatable=>false
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E726D77697A2D6163746976652D69636F6E7B666F6E742D7765696768743A3730307D2E726D77697A2D6E6578742D69636F6E7B636F6C6F723A236236623162313B646973706C61793A626C6F636B21696D706F7274616E747D2E726D77697A2D69636F';
wwv_flow_api.g_varchar2_table(2) := '6E2D6261636B67726F756E647B6261636B67726F756E643A2366616661666121696D706F7274616E747D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(40765109590141009)
,p_plugin_id=>wwv_flow_api.id(81388577542511046)
,p_file_name=>'enhancedwizard-min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
