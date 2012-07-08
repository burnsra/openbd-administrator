<!---
    Copyright (C) 2008 - Open BlueDragon Project - http://www.openbluedragon.org

    Contributing Developers:
    Matt Woodward - matt@mattwoodward.com

    This file is part of the Open BlueDragon Administrator.

    The Open BlueDragon Administrator is free software: you can redistribute
    it and/or modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    The Open BlueDragon Administrator is distributed in the hope that it will
    be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
    of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with the Open BlueDragon Administrator.  If not, see
    <http://www.gnu.org/licenses/>.
--->
<cfsilent>
  <cfset allowedIPs = Application.administrator.getAllowedIPs() />
  <cfset deniedIPs = Application.administrator.getDeniedIPs() />
</cfsilent>
<cfsavecontent variable="request.content">
  <script type="text/javascript">
    $().alert();

    function validatePasswordForm(f) {
      if (f.password.value != f.confirmPassword.value) {
        alert("The password fields do not match");
        return false;
      }

      if (f.password.value.length == 0) {
        if(confirm("Are you sure you want to set a blank password?")) {
          return true;
        } else {
          return false;
        }
      }

      return true;
    }
  </script>

<cfoutput>
  <div class="page-header">
    <h1>Security</h1>
  </div>

  <cfif StructKeyExists(session, "message") && session.message.text != "">
  <div class="alert alert-block #session.message.type#">
    <a class="close" data-dismiss="alert" herf="##">x</a>
    <h4 class="alert-heading">Attention</h4>
    #session.message.text#
  </div>
  </cfif>

  <cfif StructKeyExists(session, "errorFields") && IsArray(session.errorFields) && ArrayLen(session.errorFields) gt 0>
  <div class="alert alert-error">
    <a class="close" data-dismiss="alert" herf="##">x</a>
    <h4 class="alert-heading">Error</h4>
    <h5>The following errors occurred:</h5>
    <ul>
      <cfloop index="i" from="1" to="#ArrayLen(session.errorFields)#">
      <li>#session.errorFields[i][2]#</li>
      </cfloop>
    </ul>
  </div>
  </cfif>

  <form class="form-horizontal" name="ipAddresses" action="_controller.cfm?action=processIPAddressForm" method="post">
    <fieldset>
      <legend>IP Addresses</legend>
      <div class="control-group">
        <label class="control-label" for="allowIPs">Allow IPs</label>
        <div class="controls">
          <input type="text" class="input-xlarge" name="allowIPs" id="allowIPs" tabindex="1" />
          <p class="help-block">(comma-delimited, * for wildcard)</p>
        </div>
      </div>
      <div class="control-group">
        <label class="control-label" for="denyIPs">Deny IPs</label>
        <div class="controls">
          <input type="text" class="input-xlarge" name="denyIPs" id="denyIPs" tabindex="2" />
          <p class="help-block">(comma-delimited, * for wildcard)</p>
        </div>
      </div>
      <div class="form-actions">
        <button name="sumbit1" id="sumbit1" type="submit" class="btn btn-primary">Save changes</button>
      </div>
    </fieldset>
  </form>
  <hr />
  <form class="form-horizontal" name="adminConsolePassword" action="_controller.cfm?action=processAdminConsolePasswordForm" method="post"
    onsubmit="javascript:return validatePasswordForm(this);">
    <fieldset>
      <legend>Administration Console Password</legend>
      <div class="control-group">
        <label class="control-label" for="password">New Password</label>
        <div class="controls">
          <input type="password" class="input-xlarge" id="password" tabindex="1" />
        </div>
      </div>
      <div class="control-group">
        <label class="control-label" for="confirmPassword">Confirm Password</label>
        <div class="controls">
          <input type="password" class="input-xlarge" id="confirmPassword" tabindex="2" />
        </div>
      </div>
      <div class="form-actions">
        <button id="sumbit2" type="submit" class="btn btn-primary">Save changes</button>
      </div>
    </fieldset>
  </form>
</cfoutput>


  <cfoutput>
    <div class="row">
      <div class="pull-left">
	<h2>Security</h2>
      </div>
      <div class="pull-right">
	<button data-controls-modal="moreInfo" data-backdrop="true" data-keyboard="true" class="btn primary">More Info</button>
      </div>
    </div>
    <div id="moreInfo" class="modal hide fade">
      <div class="modal-header">
	<a href="##" class="close">&times;</a>
	<h3>Important Information Concerning Security</h3>
      </div>
      <div class="modal-body">
	<ul>
	  <li>
	    The localhost address (127.0.0.1) will never be blocked from accessing the admin console, even
	    if it is added to the deny IP list.
	  </li>
	  <li>
	    A blank allow IP list will allow access to the admin console from any IP address, provided
	    the IP address is not in the deny list.
	  </li>
	  <li>
	    A blank deny IP list will allow access to the admin console from any IP address, provided
	    the allow list is blank.
	  </li>
	  <li>
	    If the allow IP list is not blank, only those IP addresses listed in the allow
	    list will be allowed to access the admin console, even if the deny list is blank.
	  </li>
	  <li>
	    Wildcards are allowed in the IP address list to include all ranges of an IP address.
	    For example, 192.168.* would allow access from all IP addresses the begin with 192.168.
	  </li>
	  <li>
	    The deny IP list takes precedence over the allow IP list when an overlap occurs. This
	    means that if an IP address is a match for both the allow and deny list, the IP address
	    will be denied.
	  </li>
	  <li>
	    The IP access list controls access to the entire admin console.
	    <strong>This includes the login page.</strong> If the IP address from which you are
	    attempting to access the admin console is not allowed access, then you will not be
	    able to access the admin console regardless of the password setting.
	  </li>
	  <li>
	    A blank password is allowed but not recommended. Remember that even with a blank
	    password, the IP address list will control access to the admin console, so you could
	    have a blank password and control access to the admin console using only the IP
	    address lists.
	  </li>
	  <li>
	    Remember that when all else fails, you may always access your server's filesystem directly
	    and modify the bluedragon.xml file manually to correct any IP address or password issues
	    that may be blocking access to the admin console.
	  </li>
	</ul>
      </div>
    </div>
  </cfoutput>
</cfsavecontent>
