//
//  importViewModel.swift
//  grades
//
//  Created by Mayank Tiku on 12/19/24.
//

import Foundation
import SwiftSoup

@MainActor
class importGenesisViewModel: ObservableObject {
    static let shared = importGenesisViewModel()
    private init() {}
        
    func parseHTML(html: String) throws -> course? {
        var test: String = """
<html style="height: 100%;"><head>
        
        
        
        <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1,maximum-scale=1">


        <script src="/livingston/public/jquery-3.7.1.min.js"></script>

        <script src="/livingston/public/jquery-ui-1.13.2.custom/jquery-ui.min.js"></script>
        <link rel="stylesheet" href="/livingston/public/jquery-ui-1.13.2.custom/jquery-ui.min.css">


        <link rel="shortcut icon" href="/livingston/images/newIcons/genesisIcon.svg" type="image/svg+xml">
        <link href="/livingston/styles/parentsMobile2.css?rnd=20" rel="stylesheet" type="text/css">


        <link href="/livingston/manifest" rel="manifest">




        <title>Parents at Livingston Public Schools</title>




        <link rel="apple-touch-icon" href="/livingston/images/splash_screens/icon.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 430px) and (device-height: 932px) and (-webkit-device-pixel-ratio: 3) and (orientation: landscape)" href="/livingston/images/splash_screens/iPhone_14_Pro_Max_landscape.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 393px) and (device-height: 852px) and (-webkit-device-pixel-ratio: 3) and (orientation: landscape)" href="/livingston/images/splash_screens/iPhone_14_Pro_landscape.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 428px) and (device-height: 926px) and (-webkit-device-pixel-ratio: 3) and (orientation: landscape)" href="/livingston/images/splash_screens/iPhone_14_Plus__iPhone_13_Pro_Max__iPhone_12_Pro_Max_landscape.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 390px) and (device-height: 844px) and (-webkit-device-pixel-ratio: 3) and (orientation: landscape)" href="/livingston/images/splash_screens/iPhone_14__iPhone_13_Pro__iPhone_13__iPhone_12_Pro__iPhone_12_landscape.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 375px) and (device-height: 812px) and (-webkit-device-pixel-ratio: 3) and (orientation: landscape)" href="/livingston/images/splash_screens/iPhone_13_mini__iPhone_12_mini__iPhone_11_Pro__iPhone_XS__iPhone_X_landscape.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 414px) and (device-height: 896px) and (-webkit-device-pixel-ratio: 3) and (orientation: landscape)" href="/livingston/images/splash_screens/iPhone_11_Pro_Max__iPhone_XS_Max_landscape.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 414px) and (device-height: 896px) and (-webkit-device-pixel-ratio: 2) and (orientation: landscape)" href="/livingston/images/splash_screens/iPhone_11__iPhone_XR_landscape.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 414px) and (device-height: 736px) and (-webkit-device-pixel-ratio: 3) and (orientation: landscape)" href="/livingston/images/splash_screens/iPhone_8_Plus__iPhone_7_Plus__iPhone_6s_Plus__iPhone_6_Plus_landscape.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 375px) and (device-height: 667px) and (-webkit-device-pixel-ratio: 2) and (orientation: landscape)" href="/livingston/images/splash_screens/iPhone_8__iPhone_7__iPhone_6s__iPhone_6__4.7__iPhone_SE_landscape.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 320px) and (device-height: 568px) and (-webkit-device-pixel-ratio: 2) and (orientation: landscape)" href="/livingston/images/splash_screens/4__iPhone_SE__iPod_touch_5th_generation_and_later_landscape.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 1024px) and (device-height: 1366px) and (-webkit-device-pixel-ratio: 2) and (orientation: landscape)" href="/livingston/images/splash_screens/12.9__iPad_Pro_landscape.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 834px) and (device-height: 1194px) and (-webkit-device-pixel-ratio: 2) and (orientation: landscape)" href="/livingston/images/splash_screens/11__iPad_Pro__10.5__iPad_Pro_landscape.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 820px) and (device-height: 1180px) and (-webkit-device-pixel-ratio: 2) and (orientation: landscape)" href="/livingston/images/splash_screens/10.9__iPad_Air_landscape.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 834px) and (device-height: 1112px) and (-webkit-device-pixel-ratio: 2) and (orientation: landscape)" href="/livingston/images/splash_screens/10.5__iPad_Air_landscape.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 810px) and (device-height: 1080px) and (-webkit-device-pixel-ratio: 2) and (orientation: landscape)" href="/livingston/images/splash_screens/10.2__iPad_landscape.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 768px) and (device-height: 1024px) and (-webkit-device-pixel-ratio: 2) and (orientation: landscape)" href="/livingston/images/splash_screens/9.7__iPad_Pro__7.9__iPad_mini__9.7__iPad_Air__9.7__iPad_landscape.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 744px) and (device-height: 1133px) and (-webkit-device-pixel-ratio: 2) and (orientation: landscape)" href="/livingston/images/splash_screens/8.3__iPad_Mini_landscape.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 430px) and (device-height: 932px) and (-webkit-device-pixel-ratio: 3) and (orientation: portrait)" href="/livingston/images/splash_screens/iPhone_14_Pro_Max_portrait.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 393px) and (device-height: 852px) and (-webkit-device-pixel-ratio: 3) and (orientation: portrait)" href="/livingston/images/splash_screens/iPhone_14_Pro_portrait.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 428px) and (device-height: 926px) and (-webkit-device-pixel-ratio: 3) and (orientation: portrait)" href="/livingston/images/splash_screens/iPhone_14_Plus__iPhone_13_Pro_Max__iPhone_12_Pro_Max_portrait.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 390px) and (device-height: 844px) and (-webkit-device-pixel-ratio: 3) and (orientation: portrait)" href="/livingston/images/splash_screens/iPhone_14__iPhone_13_Pro__iPhone_13__iPhone_12_Pro__iPhone_12_portrait.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 375px) and (device-height: 812px) and (-webkit-device-pixel-ratio: 3) and (orientation: portrait)" href="/livingston/images/splash_screens/iPhone_13_mini__iPhone_12_mini__iPhone_11_Pro__iPhone_XS__iPhone_X_portrait.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 414px) and (device-height: 896px) and (-webkit-device-pixel-ratio: 3) and (orientation: portrait)" href="/livingston/images/splash_screens/iPhone_11_Pro_Max__iPhone_XS_Max_portrait.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 414px) and (device-height: 896px) and (-webkit-device-pixel-ratio: 2) and (orientation: portrait)" href="/livingston/images/splash_screens/iPhone_11__iPhone_XR_portrait.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 414px) and (device-height: 736px) and (-webkit-device-pixel-ratio: 3) and (orientation: portrait)" href="/livingston/images/splash_screens/iPhone_8_Plus__iPhone_7_Plus__iPhone_6s_Plus__iPhone_6_Plus_portrait.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 375px) and (device-height: 667px) and (-webkit-device-pixel-ratio: 2) and (orientation: portrait)" href="/livingston/images/splash_screens/iPhone_8__iPhone_7__iPhone_6s__iPhone_6__4.7__iPhone_SE_portrait.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 320px) and (device-height: 568px) and (-webkit-device-pixel-ratio: 2) and (orientation: portrait)" href="/livingston/images/splash_screens/4__iPhone_SE__iPod_touch_5th_generation_and_later_portrait.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 1024px) and (device-height: 1366px) and (-webkit-device-pixel-ratio: 2) and (orientation: portrait)" href="/livingston/images/splash_screens/12.9__iPad_Pro_portrait.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 834px) and (device-height: 1194px) and (-webkit-device-pixel-ratio: 2) and (orientation: portrait)" href="/livingston/images/splash_screens/11__iPad_Pro__10.5__iPad_Pro_portrait.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 820px) and (device-height: 1180px) and (-webkit-device-pixel-ratio: 2) and (orientation: portrait)" href="/livingston/images/splash_screens/10.9__iPad_Air_portrait.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 834px) and (device-height: 1112px) and (-webkit-device-pixel-ratio: 2) and (orientation: portrait)" href="/livingston/images/splash_screens/10.5__iPad_Air_portrait.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 810px) and (device-height: 1080px) and (-webkit-device-pixel-ratio: 2) and (orientation: portrait)" href="/livingston/images/splash_screens/10.2__iPad_portrait.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 768px) and (device-height: 1024px) and (-webkit-device-pixel-ratio: 2) and (orientation: portrait)" href="/livingston/images/splash_screens/9.7__iPad_Pro__7.9__iPad_mini__9.7__iPad_Air__9.7__iPad_portrait.png">
        <link rel="apple-touch-startup-image" media="screen and (device-width: 744px) and (device-height: 1133px) and (-webkit-device-pixel-ratio: 2) and (orientation: portrait)" href="/livingston/images/splash_screens/8.3__iPad_Mini_portrait.png">



            <script type="text/javascript">

                function viewDocument(courseid, assignmentid, name, type)
                {
                    window.open('/livingston/parents?tab1=studentdata&tab2=gradebook&tab3=coursesummary&studentid=268956&action=viewDocument&courseid=' + courseid + '&stripCode=' + assignmentid + '&fileName=' + encodeURIComponent(name) + '&fileType=' + type,'Document');
                }

                function displayComments(comment)
                {
                    let message = '<div style=\"padding-bottom: 5px;\"><b>Comment from Teacher</b></div>';
                    message += '' + comment + '';
                    alertDialog(message);
                }

                function printRubric(assignmentid, courseCode, courseSection, schoolCode, courseid)
                {
                    window.open('/livingston/parents?tab1=studentdata&tab2=gradebook&studentid=268956&type=class&grades=y&action=printRubric&schoolYear=2024-25&schoolCode=' + schoolCode + '&assignmentid=' + assignmentid + '&courseCode=' + courseCode + '&courseSection=' + courseSection + '&courseid=' + courseid,'','location=no,status=no');
                }

                function displayAssignmentDescription(assignmentid)
                {
                    let description = document.getElementById('assignmentDescription' + assignmentid).value;
                    let message = '<div style=\"padding-bottom: 5px;\"><b>Assignment Description</b></div>';
                    message += '\"' + description + '\"';
                    alertDialog(message);
                }

                function openDescriptionDiv(assid)
                {
                    if (document.getElementById('divDescription' + assid).style.display == 'none')
                    {
                        var ta = document.getElementById('divDescription' + assid);
                        document.getElementById('divDescription' + assid).style.display = 'inline-block';
                        document.getElementById('EndDescription' + assid).focus();
                    }
                    else
                        document.getElementById('divDescription' + assid).style.display = 'none';
                }

                function changeCourse(courseSectionKey)
                {
                    var courseCode      = courseSectionKey.substring(0,courseSectionKey.indexOf(":"));
                    var courseSection   = courseSectionKey.substring(courseSectionKey.indexOf(":") + 1);
                    location.href = '/livingston/parents?tab1=studentdata&tab2=gradebook&tab3=coursesummary&studentid=268956&mp=MP1&action=form&courseCode=' + courseCode + '&courseSection=' + courseSection;
                }

                function displayMPs()
                {
                    $( '#divChangeMarkingPeriod').dialog({
                        resizable: false,
                        height:'auto',
                        width:'auto',
                        modal: true,
                        buttons:
                            [
                                {
                                    text: "Save",
                                    'class': 'submitButton',
                                    click: function () {
                                        $( this ).dialog( "close" );
                                        var markingPeriod = document.getElementById('fldSwitchMP').value;
                                        location.href = '/livingston/parents?tab1=studentdata&tab2=gradebook&tab3=coursesummary&studentid=268956&mp=' + markingPeriod + '&action=form&courseCode=131&courseSection=4';
                                    },
                                },
                                {
                                    text: "Cancel",
                                    'class': 'cancelButton',
                                    click: function () {
                                        $( this ).dialog( "close" );
                                    },
                                }
                            ]
                    });
                }

            </script>
        <link type="text/css" rel="stylesheet" charset="UTF-8" href="https://www.gstatic.com/_/translate_http/_/ss/k=translate_http.tr.26tY-h6gH9w.L.W.O/am=BgM/d=0/rs=AN8SPfowrRiAotkQD9r4k3ANeQYGsCLZ7g/m=el_main_css"><script type="text/javascript" charset="UTF-8" src="https://translate.googleapis.com/_/translate_http/_/js/k=translate_http.tr.en_US.s1RTz78AKmM.O/am=ABA/d=1/exm=el_conf/ed=1/rs=AN8SPfoV0mNpZsiPwmQjAGAmPEL1obvtOA/m=el_main"></script></head>
        <body class="parentsBodyMobile" style="position: relative; min-height: 100%; top: 0px;">





         <!-- Needed to determine access to certain tabs (conferences, letters) -->








         <!-- Needed to determine access to certain tabs (conferences, letters) -->





            


        <script type="text/javascript">
            function changeStudent(newstudentid)
            {
                location.href = document.URL.replace('268956',newstudentid);
            }

            function header_goToTab(newTab1, appendParams)
            {
                if (appendParams == '')
                    location.href='/livingston/parents?tab1=' + newTab1 + '&action=form';
                else
                    location.href='/livingston/parents?tab1=' + newTab1 + '&action=form' + '&' + appendParams;
            }

            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            function confirmDialogWarning(questionToAsk, okFunction, cancelFunction)
            {
                confirmDialogDisplay(questionToAsk, okFunction, cancelFunction, true);
            }

            function confirmDialogDisplay(questionToAsk, okFunction, cancelFunction, useWarningIcon)
            {
                $( "#_dialog-confirm_" ).dialog({
                    resizable: false, height:'auto', width:600, modal: true,
                    title: 'Confirmation',
                    open: function()
                    {
                        $('#_confirmDialogText_').html(questionToAsk);
                        if (useWarningIcon)
                        {
                            $('#_confirmDialogIcon_').attr("src","/livingston/images/warning.gif");
                        }
                    },
                    buttons:
                        {
                            Ok: function()
                            {
                                $( this ).dialog( "close" );
                                if (okFunction!=null)
                                    okFunction();
                            },
                            Cancel: function()
                            {
                                $( this ).dialog( "close" );
                                if (cancelFunction!=null)
                                    cancelFunction();
                            }
                        }
                });
            }


            function confirmDialogMobile(questionToAsk, okFunction, cancelFunction)
            {

                $( "#_dialog-confirm_" ).dialog({
                    resizable: false, height:'auto', width:getWidth(),  modal: true,
                    title: 'Confirmation',
                    open: function()
                    {
                        $('#_confirmDialogText_').html(questionToAsk);
                        $('.ui-widget-overlay').bind('click', function()
                        {
                            $("#_dialog-confirm_").dialog('close');
                        });
                    },
                    buttons:
                        {
                            Ok: function()
                            {
                                $( this ).dialog( "close" );
                                if (okFunction!=null)
                                    okFunction();
                            },
                            Cancel: function()
                            {
                                $( this ).dialog( "close" );
                                if (cancelFunction!=null)
                                    cancelFunction();
                            }
                        },
                });
            }
            function getWidth(defaultVal)
            {
                if(!defaultVal) defaultVal = 600;
                var width = $(window).width();
                if(width > defaultVal) {
                    width = defaultVal;
                }else {
                    width -= 10;
                }

                return width;
            }

            function confirmDialog(questionToAsk, okFunction, cancelFunction)
            {
                $( "#_dialog-confirm_" ).dialog({
                    resizable: false, height:'auto', width:600, modal: true,
                    title: 'Confirmation',
                    open: function()
                    {
                        $('#_confirmDialogText_').html(questionToAsk);
                    },
                    buttons:
                        {
                            Ok: function()
                            {
                                $( this ).dialog( "close" );
                                if (okFunction!=null)
                                    okFunction();
                            },
                            Cancel: function()
                            {
                                $( this ).dialog( "close" );
                                if (cancelFunction!=null)
                                    cancelFunction();
                            }
                        }
                });
            }

            function getWidth(defaultVal)
            {
                if(!defaultVal) defaultVal = 600;
                var width = $(window).width();
                if(width > defaultVal) {
                    width = defaultVal;
                }else {
                    width -= 10;
                }

                return width;
            }

            function alertDialog(alertText, okCallback)
            {
                $( "#_dialog-alert_" ).dialog({
                    resizable: false, height:'auto', width:getWidth(400), modal: true,
                    title: 'Information',
                    open: function()
                    {
                        $('#_confirmAlertText_').html(alertText);
                    },
                    buttons:
                        {
                            Ok: function()
                            {
                                $( this ).dialog( "close" );
                                if (okCallback)
                                    okCallback();
                            }
                        }
                });
            }

            function promptDialog(questionToAsk, defaultAnswer, okFunction, cancelFunction)
            {
                if (defaultAnswer==null) defaultAnswer = '';
                $( "#_dialog-prompt_" ).dialog({
                    resizable: false, height:'auto', width:600, modal: true,
                    title: 'Prompt',
                    open: function()
                    {
                        $('#_confirmPromptText_').html(questionToAsk);
                        $('#_prompt_dialog_value_').val(defaultAnswer).removeClass('fieldValueChanged').addClass('fieldValue').focus().select();
                    },
                    buttons:
                        {
                            Ok: function()
                            {
                                $( this ).dialog( "close" );
                                if (okFunction!=null)
                                {
                                    var __prompt__answer = $('#_prompt_dialog_value_').val();
                                    if (__prompt__answer == null) __prompt__answer = '';
                                    $('#_prompt_dialog_value_').removeClass('fieldValueChanged').addClass('fieldValue');
                                    okFunction(__prompt__answer);
                                }
                            },
                            Cancel: function()
                            {
                                $( this ).dialog( "close" );
                                if (cancelFunction!=null)
                                    cancelFunction();
                            }
                        }
                });
            }

            
            
            
            
            
            
            
            

            function logout()
            {
                
                
                    
                    location.href='parents?logout=true'
            }

            function displayPasswordInReadOnlyTextField(fieldID)
            {
                var displayField = document.getElementById('readonly' + fieldID);
                var hiddenField = document.getElementById(fieldID);
                if (displayField != null && hiddenField != null)
                {
                    var displayFieldValue = displayField.innerHTML;
                    if (displayFieldValue.startsWith('****'))
                        displayFieldValue = hiddenField.value;
                    else
                        displayFieldValue = '********';
                }
                displayField.innerHTML = displayFieldValue;
            }


            function showSubTabs(id)
            {
                const tabContainers = [].slice.call(document.querySelectorAll("div[id^='subTabsFor_']"));
                tabContainers.forEach(tabContainer => {
                    if(tabContainer.classList.contains("collapse") && tabContainer.id === 'subTabsFor_' + id)
                        tabContainer.classList.remove("collapse");
                    else
                        tabContainer.classList.add("collapse");
                })
            }
        </script>
        <style>
            .headerContainer{
                position:fixed;
                /*width: 80%;*/
                top:0;
                z-index: 10;

                height: 100%;
            }

            .twoColFlex{
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .headerTab{
                font-size: 1.5em;
                font-weight: bold;
                text-align: left;
                color: #25add3;
                display: flex;
                align-items: center;
                gap: 10pt;
                opacity: 85%;
                white-space: nowrap;
                cursor:pointer
            }

            .headerTab.selected{
                opacity: 100%;
            }

            .showBodyContainer{
                height: 100%;
                width: 100%;
                position: fixed;
                background-color: black;
                filter: opacity(0.75);
                top: 0;
                z-index: 4;
            }


            .showBodyContainer.studentSelect{
                height: 100%;
                width: 100%;
                position: fixed;
                background-color: black;
                filter: opacity(0.75);
                top: 0;
                z-index: 500;
            }

            .headerTab2{
                height: 20pt;
                margin-left: 40px;
                font-size: 1.2em;
                padding: 5pt 0;
                font-weight: normal;
                font-weight: bold;
                cursor:pointer
            }

            .headerTab.selected,.headerTab2.selected,.headerTab3.selected,.tab3Mobile.selected{
                color: white;
            }

            .headerTab:hover,.headerTab2:hover,.headerTab3:hover{
                color: white;
            }

            .headerTab3{
                height: 16.5px;
                margin-left: 65px;
                font-size: 1.1em;
                font-weight: bold;
                padding: 10pt 0;
                cursor:pointer;
                white-space: nowrap;
            }

            .tab3Mobile{
                text-align: center;
                align-items: center;
                padding:2.5pt 10pt;
                line-height: 15pt;
                white-space: nowrap
            }

            .tabLink{
                text-decoration:inherit;
                color: inherit;
                font-weight: inherit;
                gap:5pt;
            }

            .tabLink:hover{
                text-decoration: none;
            }

        </style>

        <div id="mainMenu" class="mainMenu headerContainer" style="border:none" aria-label="Side Bar">
            <div style="display: flex;justify-content: space-between;flex-direction: column;height:100%">
                <div>
                    <div>
                        <div class="twoColFlex" style="margin-left: 10px;padding: 10pt 0 5pt 0;">
                            <div style="text-align: left;padding-left:5pt">
                                
                                <div><img aria-hidden="true" src="/livingston/parents/images/genesis-logo.png" alt="Genesis" style="padding-top:7px; height:34px;float: none"></div>

                                <div style="margin-top:2.5pt">
                                    
                                    <div aria-label="Currently logged in as user">mayank.tiku@lps-students.org</div>
                                </div>
                            </div>

                            
                            
                                
                                    

                                    
                                    
                                    <div style="position:relative;margin-right:10pt;">
                                        <a aria-label="View Notifications" href="/livingston/parents?tab1=messagecenter&amp;action=form&amp;studentid=268956">
                                            
                                            <img class="hoverable" aria-label="0 unseen notifications" src="/livingston/parents/images/icons8-bell-24.png" style="filter: invert(30%) sepia(77%) saturate(2868%) hue-rotate(173deg) brightness(108%) contrast(83%)" alt="">

                                            
                                        </a>
                                    </div>
                                
                            
                                
                            
                                
                            
                                
                            
                                
                            
                                
                            
                        </div>
                        
                        <div role="navigation" aria-label="Main Navigation">
                            
                            
                                
                            
                                
                                    
                                        
                                            

                                            
                                            
                                                
                                                
                                                
                                            
                                            

                                            <div style="margin: 25px 35px; text-align: left">
                                                
                                                    <a class="headerTab noselect selected tabLink" href="#" onclick="showSubTabs('studentdata')">
                                                        <img width="20" height="20" src="/livingston/parents/images/icons/sharp/students_white.png" alt="" style="filter: ">
                                                        Student Data
                                                    </a>
                                                

                                                

                                                
                                                    <div id="subTabsFor_studentdata" class="tabContainer ">

                                                        <div class="mainMenuTabs" role="navigation" aria-label="Sub pages for tabs.studentData">
                                                            
                                                            
                                                                
                                                                    
                                                                        

                                                                        
                                                                        
                                                                        
                                                                            
                                                                        

                                                                        
                                                                        
                                                                            <a class="tabLink" href="/livingston/parents?tab1=studentdata&amp;tab2=studentsummary&amp;action=form&amp;studentid=268956">
                                                                                <div class="headerTab2 noselect">
                                                                                    <div class="verticalAlign" style="white-space: nowrap">
                                                                                        Summary
                                                                                    </div>
                                                                                </div>
                                                                            </a>
                                                                            <div>
                                                                                
                                                                            </div>
                                                                        
                                                                    
                                                                
                                                            
                                                                
                                                                    
                                                                        

                                                                        
                                                                        
                                                                        
                                                                            
                                                                        

                                                                        
                                                                        
                                                                            <a class="tabLink" href="/livingston/parents?tab1=studentdata&amp;tab2=assessments&amp;action=form&amp;studentid=268956">
                                                                                <div class="headerTab2 noselect">
                                                                                    <div class="verticalAlign" style="white-space: nowrap">
                                                                                        Assessments
                                                                                    </div>
                                                                                </div>
                                                                            </a>
                                                                            <div>
                                                                                
                                                                            </div>
                                                                        
                                                                    
                                                                
                                                            
                                                                
                                                                    
                                                                        

                                                                        
                                                                        
                                                                        
                                                                            
                                                                        

                                                                        
                                                                        
                                                                            <a class="tabLink" href="/livingston/parents?tab1=studentdata&amp;tab2=attendance&amp;action=form&amp;studentid=268956">
                                                                                <div class="headerTab2 noselect">
                                                                                    <div class="verticalAlign" style="white-space: nowrap">
                                                                                        Attendance
                                                                                    </div>
                                                                                </div>
                                                                            </a>
                                                                            <div>
                                                                                
                                                                            </div>
                                                                        
                                                                    
                                                                
                                                            
                                                                
                                                                    
                                                                        

                                                                        
                                                                        
                                                                        
                                                                            
                                                                        

                                                                        
                                                                        
                                                                            <a class="tabLink" href="/livingston/parents?tab1=studentdata&amp;tab2=grading&amp;action=form&amp;studentid=268956">
                                                                                <div class="headerTab2 noselect">
                                                                                    <div class="verticalAlign" style="white-space: nowrap">
                                                                                        Grading
                                                                                    </div>
                                                                                </div>
                                                                            </a>
                                                                            <div>
                                                                                
                                                                            </div>
                                                                        
                                                                    
                                                                
                                                            
                                                                
                                                                    
                                                                        

                                                                        
                                                                        
                                                                        
                                                                            
                                                                        

                                                                        
                                                                        
                                                                            <a class="tabLink" href="/livingston/parents?tab1=studentdata&amp;tab2=feesAndFines&amp;action=form&amp;studentid=268956">
                                                                                <div class="headerTab2 noselect">
                                                                                    <div class="verticalAlign" style="white-space: nowrap">
                                                                                        Fees And Fines
                                                                                    </div>
                                                                                </div>
                                                                            </a>
                                                                            <div>
                                                                                
                                                                            </div>
                                                                        
                                                                    
                                                                
                                                            
                                                                
                                                                    
                                                                        

                                                                        
                                                                        
                                                                            
                                                                            
                                                                            
                                                                        
                                                                        

                                                                        
                                                                        
                                                                            <a class="tabLink" href="/livingston/parents?tab1=studentdata&amp;tab2=gradebook&amp;action=form&amp;studentid=268956">
                                                                                <div class="headerTab2 noselect selected">
                                                                                    <div class="verticalAlign" style="white-space: nowrap">
                                                                                        Gradebook
                                                                                    </div>
                                                                                </div>
                                                                            </a>
                                                                            <div>
                                                                                
                                                                                    
                                                                                        <div style="" role="navigation" aria-label="Sub pages for tabs.gradebook under tabs.studentData">
                                                                                            
                                                                                                
                                                                                                    
                                                                                                        
                                                                                                        
                                                                                                        <a class="tabLink" href="/livingston/parents?tab1=studentdata&amp;tab2=gradebook&amp;tab3=weeklysummary&amp;action=form&amp;studentid=268956">
                                                                                                            <div class="headerTab3 noselect">
                                                                                                                Grade Summary
                                                                                                            </div>
                                                                                                        </a>
                                                                                                    
                                                                                                
                                                                                            
                                                                                                
                                                                                                    
                                                                                                        
                                                                                                        
                                                                                                        <a class="tabLink" href="/livingston/parents?tab1=studentdata&amp;tab2=gradebook&amp;tab3=listassignments&amp;action=form&amp;studentid=268956">
                                                                                                            <div class="headerTab3 noselect">
                                                                                                                List Assignments
                                                                                                            </div>
                                                                                                        </a>
                                                                                                    
                                                                                                
                                                                                            
                                                                                                
                                                                                                    
                                                                                                        
                                                                                                        
                                                                                                            
                                                                                                            
                                                                                                            
                                                                                                        
                                                                                                        <a class="tabLink" href="/livingston/parents?tab1=studentdata&amp;tab2=gradebook&amp;tab3=coursesummary&amp;action=form&amp;studentid=268956">
                                                                                                            <div class="headerTab3 noselect selected">
                                                                                                                Course Summary
                                                                                                            </div>
                                                                                                        </a>
                                                                                                    
                                                                                                
                                                                                            
                                                                                                
                                                                                                    
                                                                                                
                                                                                            
                                                                                        </div>
                                                                                    
                                                                                
                                                                            </div>
                                                                        
                                                                    
                                                                
                                                            
                                                                
                                                                    
                                                                        

                                                                        
                                                                        
                                                                        
                                                                            
                                                                        

                                                                        
                                                                        
                                                                            <a class="tabLink" href="/livingston/parents?tab1=studentdata&amp;tab2=documents&amp;action=form&amp;studentid=268956">
                                                                                <div class="headerTab2 noselect">
                                                                                    <div class="verticalAlign" style="white-space: nowrap">
                                                                                        Documents
                                                                                    </div>
                                                                                </div>
                                                                            </a>
                                                                            <div>
                                                                                
                                                                            </div>
                                                                        
                                                                    
                                                                
                                                            
                                                                
                                                                    
                                                                        

                                                                        
                                                                        
                                                                        
                                                                            
                                                                        

                                                                        
                                                                        
                                                                            <a class="tabLink" href="/livingston/parents?tab1=studentdata&amp;tab2=forms&amp;action=form&amp;studentid=268956">
                                                                                <div class="headerTab2 noselect">
                                                                                    <div class="verticalAlign" style="white-space: nowrap">
                                                                                        Forms
                                                                                    </div>
                                                                                </div>
                                                                            </a>
                                                                            <div>
                                                                                
                                                                            </div>
                                                                        
                                                                    
                                                                
                                                            
                                                                
                                                                    
                                                                        

                                                                        
                                                                        
                                                                        
                                                                            
                                                                        

                                                                        
                                                                        
                                                                            <a class="tabLink" href="/livingston/parents?tab1=studentdata&amp;tab2=letters&amp;action=form&amp;studentid=268956">
                                                                                <div class="headerTab2 noselect">
                                                                                    <div class="verticalAlign" style="white-space: nowrap">
                                                                                        Letters
                                                                                    </div>
                                                                                </div>
                                                                            </a>
                                                                            <div>
                                                                                
                                                                            </div>
                                                                        
                                                                    
                                                                
                                                            
                                                                
                                                                    
                                                                        

                                                                        
                                                                        
                                                                        
                                                                            
                                                                        

                                                                        
                                                                        
                                                                            <a class="tabLink" href="/livingston/parents?tab1=studentdata&amp;tab2=school&amp;action=form&amp;studentid=268956">
                                                                                <div class="headerTab2 noselect">
                                                                                    <div class="verticalAlign" style="white-space: nowrap">
                                                                                        School Information
                                                                                    </div>
                                                                                </div>
                                                                            </a>
                                                                            <div>
                                                                                
                                                                            </div>
                                                                        
                                                                    
                                                                
                                                            
                                                                
                                                                    
                                                                        

                                                                        
                                                                        
                                                                        
                                                                            
                                                                        

                                                                        
                                                                        
                                                                            <a class="tabLink" href="/livingston/parents?tab1=studentdata&amp;tab2=athletics&amp;action=form&amp;studentid=268956">
                                                                                <div class="headerTab2 noselect">
                                                                                    <div class="verticalAlign" style="white-space: nowrap">
                                                                                        Athletics
                                                                                    </div>
                                                                                </div>
                                                                            </a>
                                                                            <div>
                                                                                
                                                                            </div>
                                                                        
                                                                    
                                                                
                                                            
                                                        </div>

                                                    </div>
                                                
                                            </div>
                                        
                                    
                                
                            
                                
                                    
                                        
                                    
                                
                            
                                
                            
                                
                            
                                
                                    
                                        
                                    
                                
                            
                        </div>
                    </div>

                    <div style="margin:15pt 0">
                        <hr style="width: 85%;opacity: 15%;">
                    </div>

                    <div>
                        
                            
                        
                            
                        
                            
                        
                            
                                

                                
                                
                                
                                    
                                

                                <div style="margin: 15px 35px; text-align: left;">

                                    
                                        <a class="headerTab noselect tabLink" href="#" onclick="showSubTabs('setup')" style="display: flex;align-items: center;gap:5pt">
                                            <img width="24" height="24" src="/livingston/parents/images/icons/sharp/settings_blue.png" alt="" style="filter: ">
                                            Settings
                                        </a>
                                    

                                    

                                        
                                        
                                        
                                        


                                        
                                    <div id="subTabsFor_setup" class="tabContainer collapse">
                                        
                                            <div class="mainMenuTabs" role="navigation" aria-label="Sub pages for tabs.settings">
                                                
                                                    

                                                    
                                                        
                                                            

                                                            
                                                            
                                                            
                                                                
                                                            

                                                            
                                                            
                                                                <a class="tabLink" href="/livingston/parents?tab1=setup&amp;tab2=settings&amp;action=form&amp;studentid=268956">
                                                                    <div class="headerTab2 noselect">
                                                                        <div class="verticalAlign" style="white-space: nowrap">
                                                                            General
                                                                        </div>
                                                                    </div>
                                                                </a>
                                                                <div>
                                                                    
                                                                </div>
                                                            
                                                        
                                                    
                                                
                                                    

                                                    
                                                        
                                                    
                                                
                                                    

                                                    
                                                        
                                                            

                                                            
                                                            
                                                            
                                                                
                                                            

                                                            
                                                            
                                                                <a class="tabLink" href="/livingston/parents?tab1=setup&amp;tab2=notifications&amp;action=form&amp;studentid=268956">
                                                                    <div class="headerTab2 noselect">
                                                                        <div class="verticalAlign" style="white-space: nowrap">
                                                                            Email Alerts
                                                                        </div>
                                                                    </div>
                                                                </a>
                                                                <div>
                                                                    
                                                                </div>
                                                            
                                                        
                                                    
                                                
                                            </div>
                                        
                                    </div>
                                </div>
                            
                        
                            
                        
                            
                        

                        
                        <div style="margin: 25px 35px 15px 35px; text-align: left">
                            <a class="tabLink headerTab" onclick="logout();" style="display: flex;align-items: center;gap:5pt">
                                <img width="24" height="24" src="/livingston/parents/images/icons/sharp/lock.png" alt="" style="filter: invert(30%) sepia(77%) saturate(2868%) hue-rotate(173deg) brightness(108%) contrast(83%)">
                                <span>Logout</span>
                            </a>
                        </div>
                    </div>
                </div>
                
                    
                
                    
                
                    
                
                    
                
                    

                        
                        
                        <div id="installPrompt">
                            <div>
                                <hr style="width: 85%;opacity: 15%">
                            </div>
                            <div style="margin: 25px 33px; text-align: left;">
                                <a class="tabLink headerTab noselect" href="/livingston/parents?tab1=install&amp;action=form&amp;studentid=268956" style="display: flex;align-items: center;gap:5pt">
                                    <div style="background-color: #001C35;padding:4pt 1pt 1pt 2.5pt">
                                        <img width="28" height="28" src="/livingston/images/newIcons/downloadParent2.svg" alt="">
                                    </div>
                                    Install App
                                </a>
                            </div>
                        </div>
                    
                
                    
                
            </div>

        </div>



            
                
                
                    <div class="tab3ContainerMobile" role="navigation" aria-label="Sub pages for tabs.gradebook">
                        
                            
                                
                                    
                                    
                                    

                                    <div id="" onclick="header_goToTab('studentdata&amp;tab2=gradebook&amp;tab3=weeklysummary','&amp;studentid=268956');" class="tab3Mobile noselect">Grade Summary</div>
                                    <div style="border:1px solid #25add34d;height:85%"></div>
                                    
                                    
                                
                            
                        
                            
                                
                                    
                                    
                                    

                                    <div id="" onclick="header_goToTab('studentdata&amp;tab2=gradebook&amp;tab3=listassignments','&amp;studentid=268956');" class="tab3Mobile noselect">List Assignments</div>
                                    <div style="border:1px solid #25add34d;height:85%"></div>
                                    
                                    
                                
                            
                        
                            
                                
                                    
                                    
                                    
                                        
                                        
                                        
                                        
                                    

                                    <div id="selectedTab3" onclick="header_goToTab('studentdata&amp;tab2=gradebook&amp;tab3=coursesummary','&amp;studentid=268956');" class="tab3Mobile noselect selected">Course Summary</div>
                                    <div style="border:1px solid #25add34d;height:85%"></div>
                                    
                                    
                                
                            
                        
                            
                                
                            
                        
                    </div>
                
            







        <script>
            function scrollToView()
            {
                try {
                    document.getElementById("selectedTab3").scrollIntoView({inline: "center"})
                } catch (e){}
            }

            scrollToView();
        </script>


        <div id="mainContainer">
            <div id="bodyContainer">
            </div>

            
            
            

            <script>
                let deferredPrompt;
                const registerServiceWorker = () => {
                    if ("serviceWorker" in navigator) {
                        try
                        {
                            navigator.serviceWorker.register("/livingston/sw.js", {scope: "/livingston/",})
                                .then(registration => {
                                    registration.update()
                                    registration.active.postMessage(JSON.stringify({userid: 161, baseURL: '/livingston'}))
                                });
                        }
                        catch (error)
                        {
                            console.error(`Registration failed with `);
                        }

                    }
                };

                // …
                registerServiceWorker();

                window.addEventListener("beforeinstallprompt", (e) => {
                    // Prevent Chrome 67 and earlier from automatically showing the prompt
                    console.log('Install something');

                    e.preventDefault();
                    deferredPrompt = e;
                    if (document.getElementById("installPrompt") != null)
                        document.getElementById("installPrompt").style.display = '';
                });

                function showInAppInstallPromotion()
                {

                    if(deferredPrompt)
                    {
                        // deferredPrompt is a global variable we've been using in the sample to capture the `beforeinstallevent`
                        deferredPrompt.prompt();
                        // Find out whether the user confirmed the installation or not
                        deferredPrompt.userChoice.then(e => {
                            const outcome = e.outcome;

                            // The deferredPrompt can only be used once.
                            deferredPrompt = null;
                            // Act on the user's choice
                            if (outcome === 'accepted') {
                                console.log('User accepted the install prompt.');
                                document.getElementById("installPrompt").style.display = 'none';
                                subscribeUserToPush();
                            }

                            if (outcome === 'dismissed') {
                                console.log('User dismissed the install prompt');
                            }
                        });
                    }
                    else
                    {
                        alertDialog('You either have already installed this, or your current browser/device does not support installation, please use another like Chrome or Edge. Safari if on a Mac')
                    }
                }


                function unsubscribeUserFromPush()
                {
                    navigator.serviceWorker.ready.then((reg) => {
                        reg.pushManager.getSubscription().then((subscription) => {
                            const key = subscription.getKey ? subscription.getKey('p256dh') : '';
                            const auth = subscription.getKey ? subscription.getKey('auth') : '';
                            const endpoint = subscription.endpoint;

                            subscription.unsubscribe().then((successful) => {
                                return fetch('/livingston/parents?tab1=saveSubscription&action=delete&studentid=268956', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/json',
                                    },
                                    body: JSON.stringify({
                                        endpoint: endpoint,
                                        key: key ? btoa(String.fromCharCode.apply(null, new Uint8Array(key))) : '',
                                        auth: auth ? btoa(String.fromCharCode.apply(null, new Uint8Array(auth))) : ''
                                    }),
                                }).then(() => window.location.reload());
                            }).catch((e) => {
                                // Unsubscribing failed
                            })
                        })
                    });
                }

                function subscribeUserToPush() {
                    alertDialog('Registering Notifications...')
                    fetch("/livingston/parents?tab1=saveSubscription&action=findKey&studentid=268956")
                        .then(res => res.text())
                        .then(text => JSON.parse(text))
                        .then(json => {
                            return navigator.serviceWorker
                                .register("/livingston/sw.js")
                                .then(function (registration) {
                                    const subscribeOptions = {
                                        userVisibleOnly: true,
                                        applicationServerKey: urlBase64ToUint8Array(json.key),
                                    };

                                    return registration.pushManager.subscribe(subscribeOptions);
                                })
                                .then(function (pushSubscription) {
                                    sendSubscriptionToBackEnd(pushSubscription);

                                    return pushSubscription;
                                });
                        })

                }

                function sendSubscriptionToBackEnd(subscription) {
                    const key = subscription.getKey ? subscription.getKey('p256dh') : '';
                    const auth = subscription.getKey ? subscription.getKey('auth') : '';

                    navigator.serviceWorker
                        .register("/livingston/sw.js")
                        .then(registration => {
                            registration.active.postMessage(JSON.stringify({userid: 161, baseURL: '/livingston', subEndpoint: subscription.endpoint}))
                        })


                    // body: JSON.stringify(subscription),
                    // Take byte[] and turn it into a base64 encoded string suitable for
                    // POSTing to a server over HTTP
                    const json = {
                        endpoint: subscription.endpoint,
                        key: key ? btoa(String.fromCharCode.apply(null, new Uint8Array(key))) : '',
                        auth: auth ? btoa(String.fromCharCode.apply(null, new Uint8Array(auth))) : ''
                    };
                    $.ajax({
                        url: '/livingston/parents?tab1=saveSubscription&action=subscribe&studentid=268956',
                        type: 'POST',
                        contentType: "application/json",
                        data: JSON.stringify(json),
                        dataType: "json",
                        cache: false,
                        success: function (result) {
                            window.location.reload();
                            // console.log(result);
                        },
                        error: function (result, status) {
                            window.location.reload();
                            throw new Error('Bad status code from server.');
                        }
                    })
                }

                function urlBase64ToUint8Array(base64String) {
                    let padding = '='.repeat((4 - base64String.length % 4) % 4);
                    let base64 = (base64String + padding)
                        .replace(/\\-/g, '+')
                        .replace(/_/g, '/');

                    let rawData = window.atob(base64);
                    let outputArray = new Uint8Array(rawData.length);

                    for (let i = 0; i < rawData.length; ++i) {
                        outputArray[i] = rawData.charCodeAt(i);
                    }
                    return outputArray;
                }
            </script>

            <script type="text/javascript">
                function changeStudent(newstudentid)
                {
                    location.href = document.URL.replace('268956',newstudentid);
                }

                function header_goToTab(newTab1, appendParams)
                {
                    if (appendParams == '')
                        location.href='/livingston/parents?tab1=' + newTab1 + '&action=form';
                    else
                        location.href='/livingston/parents?tab1=' + newTab1 + '&action=form' + '&' + appendParams;
                }

                function initHeader()
                {
                    fetch('/livingston/static/offline.html');
                    
                }
                function confirmDialogWarning(questionToAsk, okFunction, cancelFunction)
                {
                    confirmDialogDisplay(questionToAsk, okFunction, cancelFunction, true);
                }

                function confirmDialogDisplay(questionToAsk, okFunction, cancelFunction, useWarningIcon)
                {
                    $( "#_dialog-confirm_" ).dialog({
                        resizable: false, height:'auto', width:600, modal: true,
                        title: 'Confirmation',
                        open: function()
                        {
                            $('#_confirmDialogText_').html(questionToAsk);
                            if (useWarningIcon)
                            {
                                $('#_confirmDialogIcon_').attr("src","/livingston/images/warning.gif");
                            }
                        },
                        buttons:
                            [
                                {
                                    text: "Submit",
                                    'class': 'submitButton',
                                    click: function () {
                                        $(this).dialog("close");
                                        if (okFunction != null)
                                            okFunction();
                                    },
                                },
                                {
                                    text: 'Cancel',
                                    'class': 'cancelButton',
                                    click: function()
                                    {
                                        $( this ).dialog( "close" );
                                        if (cancelFunction!=null)
                                            cancelFunction();
                                    }
                                }
                            ]
                    });
                }


                function confirmDialogMobile(questionToAsk, okFunction, cancelFunction)
                {

                    $( "#_dialog-confirm_" ).dialog({
                        resizable: false, height:'auto', width:getWidth(),  modal: true,
                        title: 'Confirmation',
                        open: function()
                        {
                            $('#_confirmDialogText_').html(questionToAsk);
                            $('.ui-widget-overlay').bind('click', function()
                            {
                                $("#_dialog-confirm_").dialog('close');
                            });
                        },
                        buttons:
                            [
                                {
                                    text: "Submit",
                                    'class': 'submitButton',
                                    click: function () {
                                        $(this).dialog("close");
                                        if (okFunction != null)
                                            okFunction();
                                    },
                                },
                                {
                                    text: 'Cancel',
                                    'class': 'cancelButton',
                                    click: function()
                                    {
                                        $( this ).dialog( "close" );
                                        if (cancelFunction!=null)
                                            cancelFunction();
                                    }
                                }
                            ]
                    });
                }
                function getWidth(defaultVal)
                {
                    if(!defaultVal) defaultVal = 600;
                    var width = $(window).width();
                    if(width > defaultVal) {
                        width = defaultVal;
                    }else {
                        width -= 10;
                    }

                    return width;
                }

                function confirmDialog(questionToAsk, okFunction, cancelFunction)
                {
                    $( "#_dialog-confirm_" ).dialog({
                        resizable: false, height:'auto', width:600, modal: true,
                        title: 'Confirmation',
                        open: function()
                        {
                            $('#_confirmDialogText_').html(questionToAsk);
                        },
                        buttons:
                            [
                                {
                                    text: "Submit",
                                    'class': 'submitButton',
                                    click: function () {
                                        $(this).dialog("close");
                                        if (okFunction != null)
                                            okFunction();
                                    },
                                },
                                {
                                    text: 'Cancel',
                                    'class': 'cancelButton',
                                    click: function()
                                    {
                                        $( this ).dialog( "close" );
                                        if (cancelFunction!=null)
                                            cancelFunction();
                                    }
                                }
                            ]
                    });
                }

                function getWidth(defaultVal)
                {
                    if(!defaultVal) defaultVal = 600;
                    var width = $(window).width();
                    if(width > defaultVal) {
                        width = defaultVal;
                    }else {
                        width -= 10;
                    }

                    return width;
                }

                function alertDialog(alertText, okCallback)
                {
                    $( "#_dialog-alert_" ).dialog({
                        resizable: false, height:'auto', width:getWidth(400), modal: true,
                        title: 'Information',
                        open: function()
                        {
                            $('#_confirmAlertText_').html(alertText);
                        },
                        buttons:
                            {
                                Ok: function()
                                {
                                    $( this ).dialog( "close" );
                                    if (okCallback)
                                        okCallback();
                                }
                            }
                    });
                }

                function loadingDialogStart()
                {
                    $( "#_dialog-load_" ).dialog({
                        resizable: false, height:'auto', width:getWidth(400), modal: true,
                        title: 'Loading'
                    });
                }

                function loadingDialogEnd()
                {
                    $( "#_dialog-load_" ).dialog({
                        resizable: false, height:'auto', width:getWidth(400), modal: true,
                        title: 'Loading'
                    });
                }

                function promptDialog(questionToAsk, defaultAnswer, okFunction, cancelFunction)
                {
                    if (defaultAnswer==null) defaultAnswer = '';
                    $( "#_dialog-prompt_" ).dialog({
                        resizable: false, height:'auto', width:600, modal: true,
                        title: 'Prompt',
                        open: function()
                        {
                            $('#_confirmPromptText_').html(questionToAsk);
                            $('#_prompt_dialog_value_').val(defaultAnswer).removeClass('fieldValueChanged').addClass('fieldValue').focus().select();
                        },
                        buttons:
                            {
                                Ok: function()
                                {
                                    $( this ).dialog( "close" );
                                    if (okFunction!=null)
                                    {
                                        var __prompt__answer = $('#_prompt_dialog_value_').val();
                                        if (__prompt__answer == null) __prompt__answer = '';
                                        $('#_prompt_dialog_value_').removeClass('fieldValueChanged').addClass('fieldValue');
                                        okFunction(__prompt__answer);
                                    }
                                },
                                Cancel: function()
                                {
                                    $( this ).dialog( "close" );
                                    if (cancelFunction!=null)
                                        cancelFunction();
                                }
                            }
                    });
                }

                function toggleMenu(element)
                {
                    const mainMenu = $('#mainMenu')[0];
                    const downloadButton = document.getElementById("downloadButton");
                    if(mainMenu.className.indexOf('show') !== -1)
                    {
                        mainMenu.classList.remove('show');
                        // downloadButton.style.display = '';
                        $("#bodyContainer").off('click')
                        $("#bodyContainer")[0].className = '';
                        document.getElementById("hamburgerIcon").parentElement.ariaPressed = false;
                    }
                    else
                    {
                        mainMenu.classList.add('show');
                        // downloadButton.style.display = 'none';
                        $("#bodyContainer")[0].className = 'showBodyContainer';
                        $("#bodyContainer").css('filter','')
                        $("#bodyContainer").on('click',toggleMenu)
                        document.getElementById("hamburgerIcon").parentElement.ariaPressed = true;


                        try {document.querySelector(".headerTab2.selected").scrollIntoView({block: "center"})} catch (e){}
                    }
                }

                function toggleSelectableStudents(element)
                {

                    const selectableStudents = $('#selectableStudents')[0];
                    if(selectableStudents.className.indexOf('show') !== -1)
                    {
                        selectableStudents.classList.remove('show');
                        $("#bodyContainer").off('click')
                        $("#bodyContainer")[0].className = '';
                        element.ariaPressed = false;
                    }
                    else
                    {
                        selectableStudents.classList.add('show');
                        $("#bodyContainer")[0].className = 'showBodyContainer studentSelect';
                        $("#bodyContainer").css('filter','')
                        $("#bodyContainer").on('click', () => toggleSelectableStudents(element))
                        element.ariaPressed = true;
                    }
                }

                
                
                
                
                
                
                
                

                function logout()
                {
                    
                    
                        
                        location.href='parents?logout=true'
                }

                function displayPasswordInReadOnlyTextField(fieldID)
                {
                    var displayField = document.getElementById('readonly' + fieldID);
                    var hiddenField = document.getElementById(fieldID);
                    if (displayField != null && hiddenField != null)
                    {
                        var displayFieldValue = displayField.innerHTML;
                        if (displayFieldValue.startsWith('****'))
                            displayFieldValue = hiddenField.value;
                        else
                            displayFieldValue = '********';
                    }
                    displayField.innerHTML = displayFieldValue;
                }

                function selectStudent(studentid)
                {
                    location.href = 'parents?tab1=studentdata&tab2=gradebook&tab3=coursesummary&studentid=' + studentid + '&action=form';
                }

                function switchModes()
                {
                    const useNewScreens = true ? 'NO' : 'YES'
                    window.location.href = '/livingston/parents?tab1=studentdata&tab2=gradebook&tab3=coursesummary&studentid=268956&action=form&useNewScreens=' + useNewScreens
                }

            </script>


            <div class="headerBar twoColFlex" style="align-items: stretch;">
                <div style="display: inline-flex;align-items: center" onclick="toggleMenu(this);" tabindex="0" role="button" aria-pressed="false">
                    <div id="hamburgerIcon">
                        <div class="hamburgerLine"></div>
                        <div class="hamburgerLine"></div>
                        <div class="hamburgerLine"></div>
                    </div>

                    
                    <div style="color: white;font-weight: bold">
                        
                            
                                
                                    
                                
                                    
                                
                            
                                
                                    
                                
                                    
                                
                                    
                                
                                    
                                
                                    
                                
                                    
                                        
                                            
                                        
                                            
                                        
                                            
                                                Gradebook
                                            
                                        
                                            
                                        
                                    
                                
                                    
                                
                                    
                                
                                    
                                
                                    
                                
                                    
                                
                            
                                
                            
                                
                                    
                                
                                    
                                
                                    
                                
                            
                                
                                    
                                
                            
                                
                            
                        
                        
                    </div>
                </div>



                <div translate="no" style="display: flex;
                     margin: 4.5pt 0 4.5pt 0;
                    align-items: center;
                    gap: 5pt;
                    position: relative;
                    background: hsl(208 100% 18% / 1);
                    border-radius: 5pt 0 0 5pt;
                    padding: 0 4.5pt;
                    border-left: 3px solid hsl(208 100% 25% / 1);" onclick="toggleSelectableStudents(this)" tabindex="0" role="button" aria-pressed="false">
                    <img src="/livingston/images/newIcons/prevArrow.svg" width="20" height="20" style="margin-right:2.5pt" alt="">

                    <div translate="no" class="imageLabel">
                        
                            
                                <span style="overflow: hidden;">Mayank</span>
                            
                        
                    </div>

                    <img style="margin-left:7.5pt;margin-right:5pt" src="/livingston/sis/photos?type=student&amp;studentID=268956" class="imageSmall" alt="">
                </div>
            </div>



            <div id="selectableStudents" class="selectStudent" style="overflow-y: auto;z-index: 1000;white-space: nowrap">
                <h2 style="color: white;margin-left:10pt;margin-bottom:10pt">Select Student</h2>
                <hr style="margin: 0 15pt 0 10pt;border-color: hsl(193deg 88% 58%)">
                <div translate="no" style="margin-left:10pt">
                    <ul style="color: black;margin: 10pt;padding: 0">
                        
                            <li style="" class="selectStudentItem selected">
                                <a onclick="selectStudent('268956');">
                                    <div style="display: flex;gap: 5pt;align-items: center">
                                        <div><img src="/livingston/sis/photos?type=student&amp;studentID=268956" class="imageSmall" alt=""></div>
                                        <div style="overflow: hidden">
                                            Mayank&nbsp;Tiku
                                            <div style="font-size: 8pt;overflow: hidden">Livingston High School</div>
                                        </div>
                                    </div>
                                </a>
                            </li>
                        


                        
                        

                        
                    </ul>
                </div>
            </div>


            
            <div class="spacer"></div>


            
            
            
            

            

            
            <div class="container">
                <div style="text-align: right; padding: 5px 5px 0 0;">
                    <button type="button" onclick="toggleGBDisclaimer();" style="cursor: pointer; color: blue; font-size: 8pt;border:none;background: none">
                        Hide Message
                        
                    </button>
                </div>
                <div style="border: 1px solid #dadada; background-color: #dbf4fe; padding: 2px 8px 2px 8px;"><p><strong><span style="font-size:16px">Gradebooks are closed during school hours</span></strong></p></div>
            </div>
            

            

            

            

            

            
            
            
            
            

            <div style="height: 10px;"></div>

            
            


            <script>
                function _toggleFormCheckBox(id, element)
                {
                    var checkbox = document.getElementById(id);
                    var image = document.getElementById(id + "Img");
                    var parent = checkbox.parentElement;

                    if(checkbox)
                    {
                        checkbox.checked = !checkbox.checked;
                        image.className = checkbox.checked ? '' : 'hideImage';
                        parent.className = checkbox.checked ? 'formCheckbox checked' : 'formCheckbox';
                        if(element)element.ariaChecked = checkbox.checked;
                    }

                    checkbox.onchange();
                }

                function toggleDisclaimer()
                {
                    location.href = document.URL + '&toggleDisclaimer=true';
                }


                function toggleGBDisclaimer()
                {
                    location.href = document.URL + '&toggleGBDisclaimer=true';
                }

            </script>




        <table role="main" class="notecard" style=""><tbody><tr><td class="notecardTitle"> </td><td class="notecardTitle" style="width:35px;text-align:right"></td></tr><tr><td colspan="2">
            <div id="divChangeMarkingPeriod" style="display:none;" title="Switch Marking Period">
                <div style="padding:20px;" class="alignCenter">
                    Switch to
                    <select id="fldSwitchMP" class="fieldvalue">
                        
                            <option value="MP1" selected="">Marking Period 1</option>
                        
                            <option value="MP2">Marking Period 2</option>
                        
                    </select>
                </div>
            </div>

            
            
            

            <div style="text-align: center;font-weight: bold;padding-top:3px;">
                <span style="font-size: 14pt;">Course Summary for</span>
                <select name="fldCourse" id="fldCourse" class="headerFunkySelectorInput" onchange="changeCourse(this.value);">
                    
                        <option value="035-1:13">PHYSICAL EDUCATION 11</option>
                    
                        <option value="035-2:16">PHYSICAL EDUCATION 11/HEALTH 11</option>
                    
                        <option value="131:4" selected="">AP ENGLISH LANGUAGE AND COMPOSITION</option>
                    
                        <option value="241:5">AP US HISTORY 2</option>
                    
                        <option value="350:2">AP CALCULUS BC</option>
                    
                        <option value="456:2">AP PHYSICS C-MECHANICS</option>
                    
                        <option value="458:2">AP PHYSICS 2</option>
                    
                        <option value="650:1">AP ECONOMICS</option>
                    
                        <option value="752:4">AP COMPUTER SCIENCE PRINCIPLES</option>
                    
                </select>
            </div>

            
            
            
            
                
                
                    <div style="text-align: center;font-size: 12pt;padding:5px;">

                            
                        
                        
                            
                            
                        

                        
                        
                            Marking Period 1 Grade:
                        <b>
                            
                            
                                
                                    88.09%
                                
                                
                            
                            
                        </b>

                        <button type="button" class="genesisButton" id="__button1__" value="Change MP" onclick="displayMPs();" style="white-space:nowrap;;">Change MP</button><span id="__button1__div" class="fieldlabel" style="display:none">One moment...</span>

                    </div>
                
            
        </td></tr></tbody></table>
        <br>
        <table role="main" class="notecard" style=""><tbody><tr><td class="notecardTitle"> </td><td class="notecardTitle" style="width:35px;text-align:right"></td></tr><tr><td colspan="2">

                
                    <div style="font-size: 10pt;font-style: italic;padding: 0 10px 5px 0;text-align: right;">Last grade posted on 1/27/25</div>
                

                <table class="list" style="margin:auto;">
                    <tbody><tr class="listheading">
                        <td colspan="15">
                            <div style="text-align: left;font-size: 12pt;display: flex;align-items: center;justify-content: space-between;">
                                <div>
                                    <b>Assignments</b>&nbsp;
                                </div>

                                    
                                    
                                    <span style="font-size: 10pt;text-align: right">Marking Period 1<br>9/3/24 to 1/30/25</span>


                            </div>

                            
                                
                            
                        </td>
                    </tr>

                    <tr class="listheadingSmall">
                        <td nowrap="" class="cellCenter"><div style="padding:5pt">Due</div></td>
                        <td nowrap="" class="cellLeft"><div style="padding:5pt">Assignment</div></td>
                        <td nowrap="" class="cellLeft"><div style="padding:5pt">Grade</div></td>
                    </tr>

                    

                    
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        <tr class="listroweven" height="25px">
                        

                        <td class="cellCenter" height="25px"><div>Wed</div><div>1/22</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1335309" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1335309');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">JM End Discussion</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1335309" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1335309');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1335309" value="">

                               <b>JM End Discussion</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                
                                CHECKPLUSPLUS
                                
                                    / 2
                                

                                
                                    <div style="font-weight: bold;">
                                        100.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        
                        <tr class="listrowodd" height="25px">

                        <td class="cellCenter" height="25px"><div>Fri</div><div>1/17</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1331530" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1331530');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">Argument (Intro + Body)</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1331530" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1331530');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1331530" value="">

                               <b>Argument (Intro + Body)</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                7.5
                                
                                
                                    / 10
                                

                                
                                    <div style="font-weight: bold;">
                                        75.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        <tr class="listroweven" height="25px">
                        

                        <td class="cellCenter" height="25px"><div>Fri</div><div>1/10</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1330680" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1330680');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">Progress Check 5</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1330680" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1330680');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Homework
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1330680" value="">

                               <b>Progress Check 5</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                
                                CHECKPLUSPLUS
                                
                                    / 10
                                

                                
                                    <div style="font-weight: bold;">
                                        100.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        
                        <tr class="listrowodd" height="25px">

                        <td class="cellCenter" height="25px"><div>Tue</div><div>1/7</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1330698" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1330698');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">2nd Dialectical Journal</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1330698" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1330698');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1330698" value="">

                               <b>2nd Dialectical Journal</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                
                                A-
                                
                                    / 50
                                

                                
                                    <div style="font-weight: bold;">
                                        91.50%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        <tr class="listroweven" height="25px">
                        

                        <td class="cellCenter" height="25px"><div>Fri</div><div>1/3</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1328378" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1328378');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">JM 6/7</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1328378" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1328378');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1328378" value="">

                               <b>JM 6/7</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                1.5
                                
                                
                                    / 2
                                

                                
                                    <div style="font-weight: bold;">
                                        75.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        
                        <tr class="listrowodd" height="25px">

                        <td class="cellCenter" height="25px"><div>Thu</div><div>1/2</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1328163" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1328163');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">JM 5-8 Child Offenders</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1328163" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1328163');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1328163" value="">

                               <b>JM 5-8 Child Offenders</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                
                                CHECKPLUSPLUS
                                
                                    / 2.5
                                

                                
                                    <div style="font-weight: bold;">
                                        100.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        <tr class="listroweven" height="25px">
                        

                        <td class="cellCenter" height="25px"><div>Tue</div><div>12/17</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1326379" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1326379');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">MLK/Thoreau Synthesis Response</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1326379" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1326379');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1326379" value="">

                               <b>MLK/Thoreau Synthesis Response</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                
                                CHECKPLUS
                                
                                    / 5
                                

                                
                                    <div style="font-weight: bold;">
                                        85.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        
                        <tr class="listrowodd" height="25px">

                        <td class="cellCenter" height="25px"><div>Wed</div><div>12/11</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1324733" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1324733');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">Vocab Unit 3 &amp; 4</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1324733" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1324733');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Homework
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1324733" value="">

                               <b>Vocab Unit 3 &amp; 4</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                10
                                
                                
                                    / 10
                                

                                
                                    <div style="font-weight: bold;">
                                        100.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        <tr class="listroweven" height="25px">
                        

                        <td class="cellCenter" height="25px"><div>Fri</div><div>11/22</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1325661" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1325661');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">SL 20-24</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1325661" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1325661');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1325661" value="">

                               <b>SL 20-24</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                
                                CHECKPLUSPLUS
                                
                                    / 2
                                

                                
                                    <div style="font-weight: bold;">
                                        100.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        
                        <tr class="listrowodd" height="25px">

                        <td class="cellCenter" height="25px"><div>Fri</div><div>11/22</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1319920" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1319920');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">Progress Check 4</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1319920" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1319920');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Homework
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1319920" value="">

                               <b>Progress Check 4</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                
                                CHECKPLUSPLUS
                                
                                    / 10
                                

                                
                                    <div style="font-weight: bold;">
                                        100.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        <tr class="listroweven" height="25px">
                        

                        <td class="cellCenter" height="25px"><div>Thu</div><div>11/21</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1319890" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1319890');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">Rhetorical Analysis Essay (In Class)</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1319890" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1319890');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1319890" value="">

                               <b>Rhetorical Analysis Essay (In Class)</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                
                                C
                                
                                    / 50
                                

                                
                                    <div style="font-weight: bold;">
                                        75.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        
                        <tr class="listrowodd" height="25px">

                        <td class="cellCenter" height="25px"><div>Tue</div><div>11/12</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1314450" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1314450');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">SL RC (6-10)</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1314450" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1314450');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1314450" value="">

                               <b>SL RC (6-10)</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                5
                                
                                
                                    / 5
                                

                                
                                    <div style="font-weight: bold;">
                                        100.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        <tr class="listroweven" height="25px">
                        

                        <td class="cellCenter" height="25px"><div>Wed</div><div>11/6</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1313839" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1313839');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">Choice Board: Silent Spring</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1313839" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1313839');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1313839" value="">

                               <b>Choice Board: Silent Spring</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                
                                CHECKPLUSPLUS
                                
                                    / 5
                                

                                
                                    <div style="font-weight: bold;">
                                        100.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        
                        <tr class="listrowodd" height="25px">

                        <td class="cellCenter" height="25px"><div>Thu</div><div>10/31</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1312178" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1312178');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">Halloween Argument Mini Assessment</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1312178" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1312178');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1312178" value="">

                               <b>Halloween Argument Mini Assessment</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                1
                                
                                
                                    / 1
                                

                                
                                    <div style="font-weight: bold;">
                                        100.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        <tr class="listroweven" height="25px">
                        

                        <td class="cellCenter" height="25px"><div>Wed</div><div>10/30</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1315980" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1315980');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">Vocab Tone Unit 2</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1315980" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1315980');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Homework
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1315980" value="">

                               <b>Vocab Tone Unit 2</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                10
                                
                                
                                    / 10
                                

                                
                                    <div style="font-weight: bold;">
                                        100.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        
                        <tr class="listrowodd" height="25px">

                        <td class="cellCenter" height="25px"><div>Wed</div><div>10/30</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1312165" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1312165');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">Literary Quote Analysis/Reflection</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1312165" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1312165');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1312165" value="">

                               <b>Literary Quote Analysis/Reflection</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                
                                B-
                                
                                    / 25
                                

                                
                                    <div style="font-weight: bold;">
                                        81.50%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        <tr class="listroweven" height="25px">
                        

                        <td class="cellCenter" height="25px"><div>Wed</div><div>10/23</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1309371" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1309371');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">Socratic Seminar (Shame in SL and Modern Day)</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1309371" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1309371');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1309371" value="">

                               <b>Socratic Seminar (Shame in SL and Modern Day)</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                
                                B-
                                
                                    / 5
                                

                                
                                    <div style="font-weight: bold;">
                                        81.50%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        
                        <tr class="listrowodd" height="25px">

                        <td class="cellCenter" height="25px"><div>Tue</div><div>10/22</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1308325" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1308325');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">1st Dialectical Journal</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1308325" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1308325');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1308325" value="">

                               <b>1st Dialectical Journal</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                
                                A-
                                
                                    / 50
                                

                                
                                    <div style="font-weight: bold;">
                                        91.50%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        <tr class="listroweven" height="25px">
                        

                        <td class="cellCenter" height="25px"><div>Fri</div><div>10/18</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1307768" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1307768');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">SL Reading Chapters 1-5</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1307768" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1307768');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1307768" value="">

                               <b>SL Reading Chapters 1-5</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                5
                                
                                
                                    / 5
                                

                                
                                    <div style="font-weight: bold;">
                                        100.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        
                        <tr class="listrowodd" height="25px">

                        <td class="cellCenter" height="25px"><div>Fri</div><div>10/18</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1307727" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1307727');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">Syntax Analysis Assessment</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1307727" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1307727');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1307727" value="">

                               <b>Syntax Analysis Assessment</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                
                                CHECKPLUSPLUS
                                
                                    / 5
                                

                                
                                    <div style="font-weight: bold;">
                                        100.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        <tr class="listroweven" height="25px">
                        

                        <td class="cellCenter" height="25px"><div>Fri</div><div>10/18</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1307696" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1307696');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">Progress Check 3</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1307696" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1307696');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Homework
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1307696" value="">

                               <b>Progress Check 3</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                
                                CHECKPLUSPLUS
                                
                                    / 10
                                

                                
                                    <div style="font-weight: bold;">
                                        100.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        
                        <tr class="listrowodd" height="25px">

                        <td class="cellCenter" height="25px"><div>Thu</div><div>10/17</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1307027" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1307027');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">SL Chap 1-3</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1307027" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1307027');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1307027" value="">

                               <b>SL Chap 1-3</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                
                                CHECKPLUSPLUS
                                
                                    / 2.5
                                

                                
                                    <div style="font-weight: bold;">
                                        100.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        <tr class="listroweven" height="25px">
                        

                        <td class="cellCenter" height="25px"><div>Tue</div><div>10/1</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1302376" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1302376');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">Rhetorical Analysis In Class Essay</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1302376" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1302376');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1302376" value="">

                               <b>Rhetorical Analysis In Class Essay</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                
                                A-
                                
                                    / 50
                                

                                
                                    <div style="font-weight: bold;">
                                        91.50%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        
                        <tr class="listrowodd" height="25px">

                        <td class="cellCenter" height="25px"><div>Fri</div><div>9/27</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1302265" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1302265');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">Progress Check 2</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1302265" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1302265');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Homework
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1302265" value="">

                               <b>Progress Check 2</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                
                                CHECKPLUSPLUS
                                
                                    / 10
                                

                                
                                    <div style="font-weight: bold;">
                                        100.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        <tr class="listroweven" height="25px">
                        

                        <td class="cellCenter" height="25px"><div>Wed</div><div>9/25</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1300627" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1300627');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">RA Intro + Body Paragraph</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1300627" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1300627');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1300627" value="">

                               <b>RA Intro + Body Paragraph</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                9
                                
                                
                                    / 10
                                

                                
                                    <div style="font-weight: bold;">
                                        90.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        
                        <tr class="listrowodd" height="25px">

                        <td class="cellCenter" height="25px"><div>Tue</div><div>9/24</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1299082" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1299082');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">Vocab Tone Unit 1</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1299082" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1299082');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Homework
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1299082" value="">

                               <b>Vocab Tone Unit 1</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                10
                                
                                
                                    / 10
                                

                                
                                    <div style="font-weight: bold;">
                                        100.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        <tr class="listroweven" height="25px">
                        

                        <td class="cellCenter" height="25px"><div>Thu</div><div>9/19</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1297382" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1297382');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">RA Introduction</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1297382" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1297382');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1297382" value="">

                               <b>RA Introduction</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                5
                                
                                
                                    / 5
                                

                                
                                    <div style="font-weight: bold;">
                                        100.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        
                        <tr class="listrowodd" height="25px">

                        <td class="cellCenter" height="25px"><div>Wed</div><div>9/18</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1297127" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1297127');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">Progress Check 1 MC</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1297127" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1297127');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Homework
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1297127" value="">

                               <b>Progress Check 1 MC</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                
                                CHECKPLUSPLUS
                                
                                    / 10
                                

                                
                                    <div style="font-weight: bold;">
                                        100.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        <tr class="listroweven" height="25px">
                        

                        <td class="cellCenter" height="25px"><div>Thu</div><div>9/12</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1295080" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1295080');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">Choice Board 1: Edwards' "Sinners in the Hands of an Angry God"</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1295080" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1295080');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1295080" value="">

                               <b>Choice Board 1: Edwards' "Sinners in the Hands of an Angry God"</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                
                                CHECKPLUSPLUS
                                
                                    / 5
                                

                                
                                    <div style="font-weight: bold;">
                                        100.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        
                        <tr class="listrowodd" height="25px">

                        <td class="cellCenter" height="25px"><div>Fri</div><div>9/6</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1294396" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1294396');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">DOAS M.C. Quiz</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1294396" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1294396');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1294396" value="">

                               <b>DOAS M.C. Quiz</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                7
                                
                                
                                    / 10
                                

                                
                                    <div style="font-weight: bold;">
                                        70.00%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        <tr class="listroweven" height="25px">
                        

                        <td class="cellCenter" height="25px"><div>Tue</div><div>9/3</div></td>
                        <td class="cellLeft">
                            <div style="display:none;background-color: white;border:1px ridge #dcdcdc;position:absolute; width:400px;min-height:100px;overflow: hidden;" id="divDescription1292206" class="boxShadow">
                                <table width="100%" cellpadding="2" cellspacing="2">
                                    <tbody><tr><td class="cellRight" style="background-color: beige;"><span style="color:blue;cursor:pointer;text-decoration: underline;" onclick="openDescriptionDiv('1292206');">Close</span></td></tr>
                                    <tr><td class="cellCenter" style="font-weight:bold;border: 1px solid black;">DOAS In Class Essay</td></tr>
                                    <tr>
                                        <td style="font-size: 9pt;" align="center">
                                            <div style="width:94%;font-size: 9pt; min-height: 100px;text-align: left;"></div>
                                        </td>
                                    </tr>
                                    <tr><td align="center">
                                        <input type="button" id="EndDescription1292206" class="fieldvalue" value="Close Window" onclick="openDescriptionDiv('1292206');">
                                    </td></tr>
                                </tbody></table>
                            </div>
                            <div style="font-size: 8pt;font-style: italic;">
                                Assessments
                                
                            </div>
                            
                            
                            
                            
                            <input type="hidden" id="assignmentDescription1292206" value="">

                               <b>DOAS In Class Essay</b>
                            
                            

                            
                                
                                
                                
                            




















                        </td>

                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                            <td class="cellLeft" nowrap="">
                                
                                
                                
                                
                                
                                
                                
                                C+
                                
                                    / 25
                                

                                
                                    <div style="font-weight: bold;">
                                        78.50%
                                    </div>
                                

                                

                                
                            </td>
                        

                        </tr>

                        
                    
                    <tr><td colspan="15">
                        <div style="font-size: 10pt;padding:5px 0 0 10px;">Assignments graded as <b>EX (Exempt)</b> or <b>ABS (Absent)</b> do not impact a student's grade.</div>
                        <div style="font-size: 10pt;padding:5px 0 0 10px;">Assignments graded as <b>M (Missing)</b> counts as <b>0.0%</b> and <b>INC (Incomplete)</b> counts as <b>0.0%</b>.</div>
                    </td></tr>

                    <tr>
                        <td colspan="15">
                            <div style="padding-top: 20px;">
                                

                                
                                    <br>
                                    <table class="list" style="width:100%;margin:0 auto">
                                        <tbody><tr class="listheading">
                                            <td colspan="100">
                                                <div style="text-align: left;font-size: 12pt;display: flex;align-items: center;justify-content: space-between;">
                                                    <div><b>Grading Information</b></div>

                                                    <span style="font-size: 10pt;">&nbsp;&nbsp;
                                                            Marking Period 1

                                                        <img width="16" tabindex="0" class="icon" role="button" src="/livingston/images/newIcons/infoGreen.svg" style="cursor:help;vertical-align:text-bottom;" onclick="showAutoTooltip('dialog-auto-tooltip1','400');" title="Students are graded by Category Weighting in this course.  A grade is calculated by taking the average of each category and getting a value for the category based on the weight.  Each category score is then added and a total average is formulated."><script type="text/javascript">  function showAutoTooltip(dialogDivId, dialogWidth)
                {
                    $( '#' + dialogDivId).dialog({
                        title: 'Information',
                        resizable: false,
                        height:'auto',
                        width: dialogWidth,
                        modal: true,
                        buttons:
                        {
                            OK: function()
                            {
                                $( this ).dialog( "close" );
                            }
                        }
                    });
                }
        </script>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr class="listheading">
                                            <td nowrap="" class="cellLeft"><div style="padding:5pt">Category</div></td>
                                            <td nowrap="" class="cellRight"><div style="padding:5pt">Weight</div></td>
                                            
                                            
                                        </tr>
                                        
                                            
                                            
                                            
                                            
                                            
                                                
                                                
                                                
                                                
                                                
                                                
                                                <tr class="listrowodd" height="25px">
                                                    <td nowrap="" class="cellLeft"><b>Homework</b></td>
                                                    <td nowrap="" class="cellRight">10.0 %</td>
                                                    
                                                    
                                                </tr>
                                            
                                            
                                        
                                            
                                            
                                            
                                            
                                            
                                                
                                                
                                                
                                                
                                                
                                                
                                                <tr class="listroweven" height="25px">
                                                    <td nowrap="" class="cellLeft"><b>Assessments</b></td>
                                                    <td nowrap="" class="cellRight">90.0 %</td>
                                                    
                                                    
                                                </tr>
                                            
                                            
                                        
                                    </tbody></table>
                                
                            </div>

                        </td>
                    </tr>

                    
                        <tr>
                            <td colspan="15">
                                
                                <div style="padding-top: 30px;text-align: center;font-size: 14pt;"></div>
                                <table class="list" style="margin: auto;width: 100%">
                                    <tbody><tr class="listheading">
                                        <td colspan="100">
                                            <div style="text-align: left;font-size: 12pt;display: flex;align-items: center;justify-content: space-between;">
                                                <div><b>Class Attendance Summary</b></div>
                                                <span style="font-size: 10pt;text-align: right">&nbsp;&nbsp;Year to Date</span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr class="listheadingSmall">
                                        <td class="cellLeft"><div style="padding:5pt">Type</div></td>
                                        <td class="cellRight"><div style="padding:5pt">Total</div></td>
                                        <td class="cellRight"><div style="padding:5pt">Unexcused</div></td>
                                        <td class="cellRight"><div style="padding:5pt">Excused</div></td>
                                    </tr>
                                    <tr class="listroweven">
                                        <td class="cellLeft"><b>Absences&nbsp;</b></td>
                                        <td class="cellRight">4.0</td>
                                        <td class="cellRight">3.0</td>
                                        <td class="cellRight">1.0</td>
                                    </tr>
                                    <tr class="listrowodd">
                                        <td class="cellLeft"><b>Tardies&nbsp;</b></td>
                                        <td class="cellRight">0.0</td>
                                        <td class="cellRight">0.0</td>
                                        <td class="cellRight">0.0</td>
                                    </tr>
                                </tbody></table>
                            </td>
                        </tr>
                    

                </tbody></table>


        </td></tr></tbody></table>
        <br>
        <br>









        <script type="text/javascript">
            function toggleLanguage()
            {
                location.href = document.URL + '&toggleLanguage=true';
            }

            function toggleMobileSite()
            {
                location.href = document.URL + '&toggleMobileSite=true';
            }
        </script>

        <table class="footer" cellpadding="0" cellspacing="0">
            <tbody><tr>
                <td>
                </td>
                <td style="text-align: right">
                    <div id="google_translate_element"><div class="skiptranslate goog-te-gadget" dir="ltr" style=""><div id=":0.targetLanguage"><select class="goog-te-combo" aria-label="Language Translate Widget"><option value="">Select Language</option><option value="ab">Abkhaz</option><option value="ace">Acehnese</option><option value="ach">Acholi</option><option value="aa">Afar</option><option value="af">Afrikaans</option><option value="sq">Albanian</option><option value="alz">Alur</option><option value="am">Amharic</option><option value="ar">Arabic</option><option value="hy">Armenian</option><option value="as">Assamese</option><option value="av">Avar</option><option value="awa">Awadhi</option><option value="ay">Aymara</option><option value="az">Azerbaijani</option><option value="ban">Balinese</option><option value="bal">Baluchi</option><option value="bm">Bambara</option><option value="bci">Baoulé</option><option value="ba">Bashkir</option><option value="eu">Basque</option><option value="btx">Batak Karo</option><option value="bts">Batak Simalungun</option><option value="bbc">Batak Toba</option><option value="be">Belarusian</option><option value="bem">Bemba</option><option value="bn">Bengali</option><option value="bew">Betawi</option><option value="bho">Bhojpuri</option><option value="bik">Bikol</option><option value="bs">Bosnian</option><option value="br">Breton</option><option value="bg">Bulgarian</option><option value="bua">Buryat</option><option value="yue">Cantonese</option><option value="ca">Catalan</option><option value="ceb">Cebuano</option><option value="ch">Chamorro</option><option value="ce">Chechen</option><option value="ny">Chichewa</option><option value="zh-CN">Chinese (Simplified)</option><option value="zh-TW">Chinese (Traditional)</option><option value="chk">Chuukese</option><option value="cv">Chuvash</option><option value="co">Corsican</option><option value="crh">Crimean Tatar (Cyrillic)</option><option value="crh-Latn">Crimean Tatar (Latin)</option><option value="hr">Croatian</option><option value="cs">Czech</option><option value="da">Danish</option><option value="fa-AF">Dari</option><option value="dv">Dhivehi</option><option value="din">Dinka</option><option value="doi">Dogri</option><option value="dov">Dombe</option><option value="nl">Dutch</option><option value="dyu">Dyula</option><option value="dz">Dzongkha</option><option value="eo">Esperanto</option><option value="et">Estonian</option><option value="ee">Ewe</option><option value="fo">Faroese</option><option value="fj">Fijian</option><option value="tl">Filipino</option><option value="fi">Finnish</option><option value="fon">Fon</option><option value="fr">French</option><option value="fr-CA">French (Canada)</option><option value="fy">Frisian</option><option value="fur">Friulian</option><option value="ff">Fulani</option><option value="gaa">Ga</option><option value="gl">Galician</option><option value="ka">Georgian</option><option value="de">German</option><option value="el">Greek</option><option value="gn">Guarani</option><option value="gu">Gujarati</option><option value="ht">Haitian Creole</option><option value="cnh">Hakha Chin</option><option value="ha">Hausa</option><option value="haw">Hawaiian</option><option value="iw">Hebrew</option><option value="hil">Hiligaynon</option><option value="hi">Hindi</option><option value="hmn">Hmong</option><option value="hu">Hungarian</option><option value="hrx">Hunsrik</option><option value="iba">Iban</option><option value="is">Icelandic</option><option value="ig">Igbo</option><option value="ilo">Ilocano</option><option value="id">Indonesian</option><option value="iu-Latn">Inuktut (Latin)</option><option value="iu">Inuktut (Syllabics)</option><option value="ga">Irish</option><option value="it">Italian</option><option value="jam">Jamaican Patois</option><option value="ja">Japanese</option><option value="jw">Javanese</option><option value="kac">Jingpo</option><option value="kl">Kalaallisut</option><option value="kn">Kannada</option><option value="kr">Kanuri</option><option value="pam">Kapampangan</option><option value="kk">Kazakh</option><option value="kha">Khasi</option><option value="km">Khmer</option><option value="cgg">Kiga</option><option value="kg">Kikongo</option><option value="rw">Kinyarwanda</option><option value="ktu">Kituba</option><option value="trp">Kokborok</option><option value="kv">Komi</option><option value="gom">Konkani</option><option value="ko">Korean</option><option value="kri">Krio</option><option value="ku">Kurdish (Kurmanji)</option><option value="ckb">Kurdish (Sorani)</option><option value="ky">Kyrgyz</option><option value="lo">Lao</option><option value="ltg">Latgalian</option><option value="la">Latin</option><option value="lv">Latvian</option><option value="lij">Ligurian</option><option value="li">Limburgish</option><option value="ln">Lingala</option><option value="lt">Lithuanian</option><option value="lmo">Lombard</option><option value="lg">Luganda</option><option value="luo">Luo</option><option value="lb">Luxembourgish</option><option value="mk">Macedonian</option><option value="mad">Madurese</option><option value="mai">Maithili</option><option value="mak">Makassar</option><option value="mg">Malagasy</option><option value="ms">Malay</option><option value="ms-Arab">Malay (Jawi)</option><option value="ml">Malayalam</option><option value="mt">Maltese</option><option value="mam">Mam</option><option value="gv">Manx</option><option value="mi">Maori</option><option value="mr">Marathi</option><option value="mh">Marshallese</option><option value="mwr">Marwadi</option><option value="mfe">Mauritian Creole</option><option value="chm">Meadow Mari</option><option value="mni-Mtei">Meiteilon (Manipuri)</option><option value="min">Minang</option><option value="lus">Mizo</option><option value="mn">Mongolian</option><option value="my">Myanmar (Burmese)</option><option value="nhe">Nahuatl (Eastern Huasteca)</option><option value="ndc-ZW">Ndau</option><option value="nr">Ndebele (South)</option><option value="new">Nepalbhasa (Newari)</option><option value="ne">Nepali</option><option value="bm-Nkoo">NKo</option><option value="no">Norwegian</option><option value="nus">Nuer</option><option value="oc">Occitan</option><option value="or">Odia (Oriya)</option><option value="om">Oromo</option><option value="os">Ossetian</option><option value="pag">Pangasinan</option><option value="pap">Papiamento</option><option value="ps">Pashto</option><option value="fa">Persian</option><option value="pl">Polish</option><option value="pt">Portuguese (Brazil)</option><option value="pt-PT">Portuguese (Portugal)</option><option value="pa">Punjabi (Gurmukhi)</option><option value="pa-Arab">Punjabi (Shahmukhi)</option><option value="qu">Quechua</option><option value="kek">Qʼeqchiʼ</option><option value="rom">Romani</option><option value="ro">Romanian</option><option value="rn">Rundi</option><option value="ru">Russian</option><option value="se">Sami (North)</option><option value="sm">Samoan</option><option value="sg">Sango</option><option value="sa">Sanskrit</option><option value="sat-Latn">Santali (Latin)</option><option value="sat">Santali (Ol Chiki)</option><option value="gd">Scots Gaelic</option><option value="nso">Sepedi</option><option value="sr">Serbian</option><option value="st">Sesotho</option><option value="crs">Seychellois Creole</option><option value="shn">Shan</option><option value="sn">Shona</option><option value="scn">Sicilian</option><option value="szl">Silesian</option><option value="sd">Sindhi</option><option value="si">Sinhala</option><option value="sk">Slovak</option><option value="sl">Slovenian</option><option value="so">Somali</option><option value="es">Spanish</option><option value="su">Sundanese</option><option value="sus">Susu</option><option value="sw">Swahili</option><option value="ss">Swati</option><option value="sv">Swedish</option><option value="ty">Tahitian</option><option value="tg">Tajik</option><option value="ber-Latn">Tamazight</option><option value="ber">Tamazight (Tifinagh)</option><option value="ta">Tamil</option><option value="tt">Tatar</option><option value="te">Telugu</option><option value="tet">Tetum</option><option value="th">Thai</option><option value="bo">Tibetan</option><option value="ti">Tigrinya</option><option value="tiv">Tiv</option><option value="tpi">Tok Pisin</option><option value="to">Tongan</option><option value="lua">Tshiluba</option><option value="ts">Tsonga</option><option value="tn">Tswana</option><option value="tcy">Tulu</option><option value="tum">Tumbuka</option><option value="tr">Turkish</option><option value="tk">Turkmen</option><option value="tyv">Tuvan</option><option value="ak">Twi</option><option value="udm">Udmurt</option><option value="uk">Ukrainian</option><option value="ur">Urdu</option><option value="ug">Uyghur</option><option value="uz">Uzbek</option><option value="ve">Venda</option><option value="vec">Venetian</option><option value="vi">Vietnamese</option><option value="war">Waray</option><option value="cy">Welsh</option><option value="wo">Wolof</option><option value="xh">Xhosa</option><option value="sah">Yakut</option><option value="yi">Yiddish</option><option value="yo">Yoruba</option><option value="yua">Yucatec Maya</option><option value="zap">Zapotec</option><option value="zu">Zulu</option></select></div>Powered by <span style="white-space:nowrap"><a class="VIpgJd-ZVi9od-l4eHX-hSRGPd" href="https://translate.google.com" target="_blank"><img src="https://www.gstatic.com/images/branding/googlelogo/1x/googlelogo_color_42x16dp.png" width="37px" height="14px" style="padding-right: 3px" alt="Google Translate">Translate</a></span></div></div>
                    <script type="text/javascript">
                        // TODO: If any changes are made to includedLanguages, copy them to parentsFooterMobile.jsp and openRegistration/header.jsp

                        function googleTranslateElementInit() {
                            new google.translate.TranslateElement({pageLanguage: 'en'}, 'google_translate_element'); }
                    </script>
                    <script type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
                    ©Copyright Genesis Educational Services,Inc.
                </td>
            </tr>
        </tbody></table>





            
                
                
                    <div style="display:none">
                        <div id="dialog-auto-tooltip1" title="">
                            
                                                            Students are graded by <b>Category Weighting</b> in this course.  A grade is calculated by taking the average of each category and getting a value for the category based on the weight.  Each category score is then added and a total average is formulated.
                                                        
                        </div>
                    </div>
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            
                
                
            

        <div style="display:none">
            <div id="_dialog-confirm_" title="" style="">
                <table>
                    <tbody><tr>
                        <td> <img src="/livingston/images/help2_48.png"> </td>
                        <td>
                            <div id="_confirmDialogText_">

                            </div>
                        </td>
                    </tr>
                </tbody></table>
            </div>
            <div id="_dialog-prompt_" title="" style="background-color:#FFFFFF">
                <table>
                    <tbody><tr>
                        <td> <img src="/livingston/images/help2_48.png"> </td>
                        <td>
                            <div id="_confirmPromptText_">

                            </div>
                            <input type="text" class="fieldvalue " name="_prompt_dialog_value_" id="_prompt_dialog_value_" size="50" maxlength="255" onchange="this.className='fieldvaluechanged ';" onclick="" onkeyup="" onkeydown="" oninput="" onblur=";" value="" autocomplete="off">
                        </td>
                    </tr>
                </tbody></table>
            </div>
            <div id="_dialog-alert_" title="" style="background-color:#FFFFFF">
                <table>
                    <tbody><tr>
                        <td> <img src="/livingston/images/info_48.png"> </td>
                        <td>
                            <div id="_confirmAlertText_">

                            </div>
                        </td>
                    </tr>
                </tbody></table>
            </div>
            <div id="_dialog-load_" title="" style="background-color:#FFFFFF">
                <table>
                    <tbody><tr>
                        <td> <img src="/livingston/images/loading.gif"> </td>
                        <td>
                            <div>
                                One moment...
                            </div>
                        </td>
                    </tr>
                </tbody></table>
            </div>
        </div>
        <br>
        <br>
        <br>
        </div><div id="goog-gt-tt" class="VIpgJd-yAWNEb-L7lbkb skiptranslate" style="border-radius: 12px; margin: 0 0 0 -23px; padding: 0; font-family: 'Google Sans', Arial, sans-serif;" data-id=""><div id="goog-gt-vt" class="VIpgJd-yAWNEb-hvhgNd"><div class=" VIpgJd-yAWNEb-hvhgNd-l4eHX-i3jM8c"><img src="https://fonts.gstatic.com/s/i/productlogos/translate/v14/24px.svg" width="24" height="24" alt=""></div><div class=" VIpgJd-yAWNEb-hvhgNd-k77Iif-i3jM8c"><div class="VIpgJd-yAWNEb-hvhgNd-IuizWc" dir="ltr">Original text</div><div id="goog-gt-original-text" class="VIpgJd-yAWNEb-nVMfcd-fmcmS VIpgJd-yAWNEb-hvhgNd-axAV1"></div></div><div class="VIpgJd-yAWNEb-hvhgNd-N7Eqid ltr"><div class="VIpgJd-yAWNEb-hvhgNd-N7Eqid-B7I4Od ltr" dir="ltr"><div class="VIpgJd-yAWNEb-hvhgNd-UTujCb">Rate this translation</div><div class="VIpgJd-yAWNEb-hvhgNd-eO9mKe">Your feedback will be used to help improve Google Translate</div></div><div class="VIpgJd-yAWNEb-hvhgNd-xgov5 ltr"><button id="goog-gt-thumbUpButton" type="button" class="VIpgJd-yAWNEb-hvhgNd-bgm6sf" title="Good translation" aria-label="Good translation" aria-pressed="false"><span id="goog-gt-thumbUpIcon"><svg width="24" height="24" viewBox="0 0 24 24" focusable="false" class="VIpgJd-yAWNEb-hvhgNd-THI6Vb NMm5M"><path d="M21 7h-6.31l.95-4.57.03-.32c0-.41-.17-.79-.44-1.06L14.17 0S7.08 6.85 7 7H2v13h16c.83 0 1.54-.5 1.84-1.22l3.02-7.05c.09-.23.14-.47.14-.73V9c0-1.1-.9-2-2-2zM7 18H4V9h3v9zm14-7l-3 7H9V8l4.34-4.34L12 9h9v2z"></path></svg></span><span id="goog-gt-thumbUpIconFilled"><svg width="24" height="24" viewBox="0 0 24 24" focusable="false" class="VIpgJd-yAWNEb-hvhgNd-THI6Vb NMm5M"><path d="M21 7h-6.31l.95-4.57.03-.32c0-.41-.17-.79-.44-1.06L14.17 0S7.08 6.85 7 7v13h11c.83 0 1.54-.5 1.84-1.22l3.02-7.05c.09-.23.14-.47.14-.73V9c0-1.1-.9-2-2-2zM5 7H1v13h4V7z"></path></svg></span></button><button id="goog-gt-thumbDownButton" type="button" class="VIpgJd-yAWNEb-hvhgNd-bgm6sf" title="Poor translation" aria-label="Poor translation" aria-pressed="false"><span id="goog-gt-thumbDownIcon"><svg width="24" height="24" viewBox="0 0 24 24" focusable="false" class="VIpgJd-yAWNEb-hvhgNd-THI6Vb NMm5M"><path d="M3 17h6.31l-.95 4.57-.03.32c0 .41.17.79.44 1.06L9.83 24s7.09-6.85 7.17-7h5V4H6c-.83 0-1.54.5-1.84 1.22l-3.02 7.05c-.09.23-.14.47-.14.73v2c0 1.1.9 2 2 2zM17 6h3v9h-3V6zM3 13l3-7h9v10l-4.34 4.34L12 15H3v-2z"></path></svg></span><span id="goog-gt-thumbDownIconFilled"><svg width="24" height="24" viewBox="0 0 24 24" focusable="false" class="VIpgJd-yAWNEb-hvhgNd-THI6Vb NMm5M"><path d="M3 17h6.31l-.95 4.57-.03.32c0 .41.17.79.44 1.06L9.83 24s7.09-6.85 7.17-7V4H6c-.83 0-1.54.5-1.84 1.22l-3.02 7.05c-.09.23-.14.47-.14.73v2c0 1.1.9 2 2 2zm16 0h4V4h-4v13z"></path></svg></span></button></div></div><div id="goog-gt-votingHiddenPane" class="VIpgJd-yAWNEb-hvhgNd-aXYTce"><form id="goog-gt-votingForm" action="//translate.googleapis.com/translate_voting?client=te" method="post" target="votingFrame" class="VIpgJd-yAWNEb-hvhgNd-aXYTce"><input type="text" name="sl" id="goog-gt-votingInputSrcLang"><input type="text" name="tl" id="goog-gt-votingInputTrgLang"><input type="text" name="query" id="goog-gt-votingInputSrcText"><input type="text" name="gtrans" id="goog-gt-votingInputTrgText"><input type="text" name="vote" id="goog-gt-votingInputVote"></form><iframe name="votingFrame" frameborder="0"></iframe></div></div></div>


        <div class="VIpgJd-ZVi9od-aZ2wEe-wOHMyf"><div class="VIpgJd-ZVi9od-aZ2wEe-OiiCO"><svg xmlns="http://www.w3.org/2000/svg" class="VIpgJd-ZVi9od-aZ2wEe" width="96px" height="96px" viewBox="0 0 66 66"><circle class="VIpgJd-ZVi9od-aZ2wEe-Jt5cK" fill="none" stroke-width="6" stroke-linecap="round" cx="33" cy="33" r="30"></circle></svg></div></div></body></html>
"""
        let doc = try SwiftSoup.parse(test)
        
        let courseName = try parseTitle(doc)
        
        // Find all table rows that contain grade information
        let rows = try doc.select("tr.listroweven, tr.listrowodd").array()
        
        var grades: [grade] = []
        
        // iterate through each row
        for row in rows {
            // find just all the cells before parsing
            let cells = try row.select("td").array()
            if cells.count >= 7 {
                
                let date = try parseDate(cells)
                let (name, category) = try parseNameCateg(cells)
                let (earned, total) = try parsePoints(cells)
                
                // add to list
                let grade = grade(name: name, points: total, earned: earned, weight: 1, date: date, category: category)
                grades.append(grade)
            }
        }
        var cat = try parseCategories(doc)
        print(cat)
        
        // if didnt parse anything
        if grades.isEmpty {
            return nil
        }
        
        //if its caregoy weighted
        if cat.isEmpty {
            return course(name: courseName, teacher: "", isPoints: true, grades: grades)
        }
        
        for (ind, i) in cat.enumerated() {
            for j in grades {
                if j.category == i.name {
                    cat[ind].grades.append(j)
                }
            }
        }
        
        return course(name: courseName, teacher: "", grades: grades, categories: cat)
    }
    
    private func parseDate(_ cells: [Element]) throws -> Date {
        do {
            let dateDiv = try cells[0].select("div").array()
            var comps = DateComponents()
            if dateDiv.count >= 2 {
                let dayOfWeek =  "\(try dateDiv[0].text())"
                let dateTot = "\(try dateDiv[1].text())"
                
                let datearr = dateTot.split(separator: "/")
                if datearr.count >= 2 {
                    comps.month = Int(datearr[0])
                    comps.day = Int(datearr[1])
                    comps.year = self.findClosestYear(month: comps.month!, day: comps.day!, dayOfWeek: dayOfWeek.strTodowNum())
                } else {
                    return Date()
                }
            }
            return Calendar.current.date(from: comps)!
            
        } catch {
            print("some error happeded when tryna find the date: \(error)")
            return Date()
        }
    }
    
    private func parseTitle(_ doc: Document) throws -> String {
        let courseSelect = try doc.select("select#fldCourse").first()
        let selectedCourse = try courseSelect?.select("option[selected]").first()
        let courseName = try selectedCourse?.text().capitalized ?? ""
        return courseName
    }
    
    private func parseNameCateg(_ cells: [Element]) throws -> (String, String) {
        // Extract name info from second cell
        var name = "Unknown"
        do {
            name = try cells[3].text()
        } catch {
            print("error parsing name: \(error)")
        }
        
        // Extract assignment info from second cell
        var category = "Default Category"
        do {
            var categoryCell = try cells[1].text()
            categoryCell = "teouh"+categoryCell
            category = categoryCell.components(separatedBy: name)[1].trimmingCharacters(in: .whitespaces)
        } catch {
            print("error parsing category: \(error)")
        }
        
        return (name, category)
    }
    
    private func parsePoints(_ cells: [Element]) throws -> (Double, Double) {
        var score = 0.0
        var toal = 0.0
        do {
            let gradeText = try cells[6].text()
            let trimmedArray = String(gradeText).split(separator: "/")
            if trimmedArray.count>=2 {
                let earn = trimmedArray[0]
                let total = trimmedArray[1].trimmingCharacters(in: .whitespaces)
                
                // IF right side is a point
                if let r = total.range(of: #"\A\d+(\.*\d+)?"#, options: .regularExpression) {
                    toal = Double(total[r]) ?? 0.0
                }
                
                // IF THE LEFT SIDE IS CHECK++ OR ETC
                if let range = earn.range(of: #"\S+\s*\z"#, options: .regularExpression) {
                    let tstr = earn[range].trimmingCharacters(in: .whitespaces)
                    if let s = Double(tstr) {
                        score = s
                    } else if tstr == "CHECKPLUSPLUS" {
                        score = toal
                    } else if tstr == "CHECKPLUS" {
                        score = 0.85*toal
                    } else if tstr == "CHECK" {
                        score = 0.7*toal
                    } else if tstr == "A+" {
                        score = 0.975*toal
                    } else if tstr == "A" {
                        score = 0.965*toal
                    } else if tstr == "A-" {
                        score = 0.915*toal
                    } else if tstr == "B+" {
                        score = 0.885*toal
                    } else if tstr == "B" {
                        score = 0.85*toal
                    } else if tstr == "B-" {
                        score = 0.815*toal
                    } else if tstr == "C+" {
                        score = 0.785*toal
                    } else if tstr == "C" {
                        score = 0.75*toal
                    } else if tstr == "C-" {
                        score = 0.715*toal
                    } else if tstr == "D+" {
                        score = 0.685*toal
                    } else if tstr == "D" {
                        score = 0.65*toal
                    } else if tstr == "D-" {
                        score = 0.615*toal
                    } else/* if tstr == "F"*/ {
                        score = 0.6*toal
                    }
                }
            }
        } catch {
            print("error parsing points/earned: \(error)")
        }
        
        return (score, toal)
    }
    
    private func parseCategories(_ doc: Document) throws -> [category] {
        var categories: [category] = []
        
        if let categoryTable = try doc.select("table.list").filter({ try $0.text().contains("Grading Information") }).first {
            let categoryRows = try categoryTable.select("tr:has(td.cellLeft > b)").array()
            
            for row in categoryRows {
                let cells = try row.select("td").array()
                if cells.count >= 2 {
                    let categoryName = try cells[0].select("b").text()
                    let wt = try cells[1].text()
                    if !wt.contains("%") { continue }
                    let weightText = wt.replacingOccurrences(of: "%", with: "").trimmingCharacters(in: .whitespaces)
                    if let weight = Double(weightText) {
                        categories.append(category(name: categoryName, grades: [], weight: weight/100.0))
                    }
                }
            }
        }
        return categories
    }
    
    private func findClosestYear(month: Int, day: Int, dayOfWeek: Int, searchRange: Int = 50) -> Int? {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        var dateComponents = DateComponents()
        dateComponents.month = month
        dateComponents.day = day
        
        // Search both backwards and forwards from current year
        var closestYear: Int?
        var smallestDiff = Int.max
        
        for year in (currentYear - searchRange)...(currentYear + searchRange) {
            dateComponents.year = year
            
            if let date = calendar.date(from: dateComponents),
               let weekday = calendar.dateComponents([.weekday], from: date).weekday,
               weekday == dayOfWeek {
                
                let diff = abs(year - currentYear)
                if diff < smallestDiff {
                    smallestDiff = diff
                    closestYear = year
                }
            }
        }
        
        return closestYear
    }
}
