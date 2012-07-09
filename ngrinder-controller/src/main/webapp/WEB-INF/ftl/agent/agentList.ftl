<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>nGrinder Agent List</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="nGrinder Agent List">
        <meta name="author" content="Tobi">

        <link rel="shortcut icon" href="favicon.ico"/>
        <link href="${Request.getContextPath()}/css/bootstrap.min.css" rel="stylesheet">
        <link href="${Request.getContextPath()}/css/bootstrap-responsive.min.css" rel="stylesheet">
        
        <style>
            body {
                padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
            }
        </style>
        
        <input type="hidden" id="contextPath" value="${Request.getContextPath()}">
        <#setting number_format="computer">
    </head>

    <body>
        <#include "../common/navigator.ftl">
        <div class="container">
            <div class="row">
                <div class="span10 offset1">
                    <div class="row">
                        <div class="span10">
                            <a class="btn" href="#uploadScriptModal" id="connectBtn" data-toggle="modal">
                                <i class="icon-ok-circle"></i>
                                Connect
                            </a>
                            <a class="btn" href="#uploadScriptModal" id="disconnectBtn" data-toggle="modal">
                                <i class="icon-remove-circle"></i>
                                Disconnect
                            </a>
                            <div class="form-inline pull-right" >
                                <input type="text" class="search-query" placeholder="Keywords" id="searchText" value="${keywords!}">
                                <button type="submit" class="btn" id="searchBtn"><i class="icon-search"></i>Search</button>
                            </div>
			                <table class="table" id="scriptTable" style="margin-bottom:10px;">
			                    <colgroup>
			                        <col width="30">
			                        <col width="100">
			                        <col width="110">
			                        <col width="110">
			                        <col width="60">
			                        <col width="60">
			                        <col width="60">
			                        <col width="160">
			                        <col width="20">
			                    </colgroup>
			                    <thead>
			                        <tr>
			                            <th class="center"><input type="checkbox" class="checkbox" value=""></th>
			                            <th>IP | Domain</th>
			                            <th>Application Port</th>
			                            <th>Application Name</th>
			                            <th>Type</th>
			                            <th>Region</th>
			                            <th>Status</th>
			                            <th class="noClick">Operation</th>
			                            <th></th>
			                            <th></th>
			                        </tr>
			                    </thead>
			                    <tbody>
			                        <#assign agentList = agents.content/>
			                        <#if agentList?has_content>
			                        <#list agentList as agent>
			                        <tr>
			                            <td><input type="checkbox" value="${agent.id}"></td>
			                            <td class="left"><a href="${Request.getContextPath()}/agent/detail?id=${agent.id}" target="_self">${agent.ip}</a></td>
			                            <td>${(agent.appPort)!}</td>
			                            <td>${(agent.appName)!}</td>
			                            <td>${(agent.type)!}</td>
			                            <td>${(agent.region)!}</td>
			                            <td>${(agent.status)!}</td>
			                            <td>
											<div class="btn-group" data-toggle="buttons-radio">
											    <a class="btn btn-mini" href="${Request.getContextPath()}/agent/connect?ids=${agent.id}&isConnect=true">Connect</a>
											    <a class="btn btn-mini" href="${Request.getContextPath()}/agent/connect?ids=${agent.id}&isConnect=false">Disconnect</a>
											</div>
			                            </td>
			                            <td>
			                                <a href="${Request.getContextPath()}/agent/delete?ids=${agent.id}" title="Delete this agent"><i class="icon-remove"></i></a>
			                            </td>
			                        </tr>
			                        </#list>
			                        <#else>
			                            <tr>
			                                <td colspan="8">
			                                    No data to display.
			                                </td>
			                            </tr>
			                        </#if>
			                    </tbody>
			                </table>
                        </div>
                    </div>
                <!--content-->
                <#include "../common/copyright.ftl">
                </div>
            </div>
        </div>
        <script src="${Request.getContextPath()}/js/jquery-1.7.2.min.js"></script>
        <script src="${Request.getContextPath()}/js/bootstrap.min.js"></script>
        <script src="${Request.getContextPath()}/js/utils.js"></script>
        <script>
            $(document).ready(function() {
                $("#connectBtn").on('click', function() {
                    var ids = "";
                    var list = $("td input:checked");
                    if(list.length == 0) {
                        alert("Please select any agents first.");
                        return;
                    }
                    var agentArray = [];
                    list.each(function() {
                        agentArray.push($(this).val());
                    });
                    ids = agentArray.join(",");
                    document.location.href = "${Request.getContextPath()}/agent/connect?ids=" + ids + "&isConnect=true";
                });
            });
            
        </script>
    </body>
</html>