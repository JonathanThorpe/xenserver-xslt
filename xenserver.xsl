<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
 version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml">

   <!--
   Proof of concept XSLT template for XenServer.
   Version: 0.4
   Author: Jonathan Thorpe <jt@jonthorpe.net>

      Usage: Add the line following line to your XAPI database XML file and open the XML file in any modern browser.
      <?xml-stylesheet type="text/xsl" href="xenserver.xsl"?>

      Changelog:
      0.4: Minor update - show host on which VM is running.
      0.3: VBD display.
      0.2: Changes to CSS, additional content, including VM summary.
      0.1: Initial Release.

   To use it add the following line into the database file
   # <?xml-stylesheet type="text/xsl" href="xenserver-0.3.xsl"?>
   Then open the database file with your favourite browser.
   -->

   <xsl:output method="html"/>
   <xsl:template match="database">
      <html>
         <head>
		      <title>XenServer Database Viewer</title>
		      <style>
               body {
               	font: 9pt Arial, sans-serif;
               }
               
               table {
                  border: 1px solid #000000;
                  width: 100%;
                  border-collapse: collapse;
                  font: 9pt Arial, sans-serif;
               }
               
               td {
                  border: 1px solid #000000;
                  padding: 2px;
               }

               th {
                  background-color: #000000;
                  border: 1px solid #FFFFFF;
                  color: #FFFFFF;
               }

               h1, h2{
                  border-bottom: 1px dotted #000000;
               }

               h1 {
               	font-size: 1.5em;
               }

               h2 {
               	font-size: 1.2em;
                  margin-top: 20px;
               }

               h3 {
               	font-size: 1.1em;
               }
            </style>
         </head>
         <body>
	         <div id="headerBox">
               <a name="top"/>
               <h1>XenServer Pool Information</h1>
               <p>XenServer XSLT Stylesheet.</p>
               <h2>Contents</h2>
               <ul>
                  <li><a href="#pool">Pool Information</a></li>
                     <ul>
                        <li><a href="#pool_general">General Information</a></li>
                        <li><a href="#pool_config">Pool Configuration</a></li>
                        <li><a href="#pool_patches">Patches / Hotfixes</a></li>
                        <li><a href="#pool_sr">Storage Repositories</a></li>
                        <li><a href="#pool_networks">Networks</a></li>
                     </ul>
                     <li><a href="#host">XenServer Host Configuration</a></li>
                     <ul>
                        <li><a href="#host_summary">Host Summary and Licensing</a></li>
                        <li><a href="#host_cpus">CPUs</a></li>
                        <li><a href="#host_memory">Memory</a></li>
                        <li><a href="#host_pbd">Physical Block Devices</a></li>
                        <li><a href="#host_network">Physical Network Interfaces</a></li>
                        <li><a href="#host_network">Physical Network Interface Details</a></li>
                        <li><a href="#host_patches">Patches / Hotfixes</a></li>
                     </ul>
                     <li><a href="#vm">XenServer Virtual Machines</a></li>
                     <ul>
                        <li><a href="#vm_summary">Summary</a></li>
                        <li><a href="#vm_details">Virtual Machine Details</a></li>
                        <li><a href="#vbd_details">Virtual Block Devices</a></li>
                     </ul>                     
               </ul>
            </div>

            <a name="pool"/>
            <h1>Pool Information</h1>

            <a name="pool_general"/>
            <h2>General Information</h2>
            <table>
               <tr>
                  <td>Product Name:</td>
                  <td><xsl:apply-templates select="/database/manifest/pair[@key='product_brand']" /></td>
               </tr>
               <tr>
                  <td>Product Version:</td>
                  <td><xsl:apply-templates select="/database/manifest/pair[@key='product_version']" /></td>
               </tr>
               <tr>
                  <td>Build Number:</td>
                  <td><xsl:apply-templates select="/database/manifest/pair[@key='build_number']" /></td>
               </tr>
            </table>

            <a name="pool_config"/>           
            <h2>Pool Configuration</h2>
            <table>
               <tr>
                  <td>Pool Name:</td>
                  <td><xsl:apply-templates select="/database/table[@name='pool']/row/@name_label" /></td>
               </tr>
               <tr>
                  <td>Pool UUID:</td>
                  <td><xsl:apply-templates select="/database/table[@name='pool']/row/@uuid" /></td>
               </tr>
            </table>

            <a name="pool_patches"/>
            <h2>Patches / Hotfixes</h2>
            <p>Please note that these patches are available for installation, but have not necessarily been applied. Please refer to the patches in the XenServer Host section below.</p>
            <table>
               <tr>
                  <th>Patch Name</th>
                  <th>Description</th>
                  <th>After-install Guidance</th>
               </tr>
               <xsl:apply-templates select="/database/table[@name='pool_patch']/row" />
            </table>

            <a name="pool_sr"/>
            <h2>Storage Repositories</h2>
            <table>
               <tr>
                  <th>Name</th>
                  <th>Description</th>
                  <th>Shared</th>
                  <th>Storage Type</th>
                  <th>Content Type</th>
                  <th>Physical Size</th>
                  <th>Allocation</th>
                  <th>UUID</th>
               </tr>
               <xsl:apply-templates select="/database/table[@name='SR']/row" />
       </table>

       <a name="pool_networks"/>
       <h2>Networks</h2>
       <table>
          <tr>
             <th>Name</th>
             <th>Description</th>
             <th>Bridge</th>
             <th>Other Configuration</th>
             <th>UUID</th>
          </tr>
          <xsl:apply-templates select="/database/table[@name='network']/row" >
             <xsl:sort select="@bridge"/>
          </xsl:apply-templates>
       </table>

       <a name="host"/>
       <h1>XenServer Hosts</h1>
       <a name="host_summary"/>
       <h2>Host Summary</h2>
       <table>
          <tr>
             <th>Name</th>
             <th>Hostname</th>
             <th>Description</th>
             <th>Management IP</th>
             <th>iSCSI IQN</th>
             <th>License Info</th>
             <th>UUID</th>
          </tr>
          <xsl:apply-templates select="/database/table[@name='host']/row" >
             <xsl:sort select="@name__label"/>
          </xsl:apply-templates>
       </table>

       <a name="host_cpus"/>
       <h2>Host CPU Configuration</h2>
       <xsl:for-each select="/database/table[@name='host']/row">
          <xsl:sort select="@name__label"/>
          <xsl:variable name="host_ref" select="@ref"/>
          <h3><xsl:value-of select="@name__label"/></h3>
             <table>
                <tr>
                   <th>Number</th>
                   <th>Vendor</th>
                   <th>Model Name</th>
                   <th>Model</th>
                   <th>Stepping</th>
                   <th>Family</th>
                   <th>Flags</th>
                </tr>
                <xsl:apply-templates select="/database/table[@name='host_cpu']/row[@host=$host_ref]" >
                   <xsl:sort select="@number"/>
                </xsl:apply-templates>
              </table>
        </xsl:for-each>

       <a name="host_memory"/>
       <h2>Memory Metrics</h2>
       <table>
          <tr>
             <th>Host</th>
             <th>Total</th>
             <th>Free</th>
          </tr>
          <xsl:for-each select="/database/table[@name='host']/row">
             <xsl:sort select="@name__label"/>
             <xsl:variable name="metric_ref" select="@metrics"/>
             <tr>
                <td><xsl:value-of select="@name__label"/></td>
                   <xsl:apply-templates select="/database/table[@name='host_metrics']/row[@ref=$metric_ref]" />
                </tr>
           </xsl:for-each>
       </table>

       <a name="host_pbd"/>
       <h2>Physical Block Devices</h2>
       <xsl:for-each select="/database/table[@name='host']/row">
          <xsl:sort select="@name__label"/>
             <xsl:variable name="host_ref" select="@ref"/>
             <h3><xsl:value-of select="@name__label"/></h3>
             <table>
                <tr>
                   <th>Storage Repository Name (UUID)</th>
                   <th>Currently Attached</th>
                   <th>Device Config</th>
                   <th>UUID</th>
                 </tr>
                 <xsl:for-each select="/database/table[@name='PBD']/row[@host=$host_ref]" >
                    <xsl:variable name="sr_ref" select="@SR"/>
                    <xsl:variable name="sr_name" select="/database/table[@name='SR']/row[@ref=$sr_ref]/@name__label" />
                    <xsl:variable name="sr_uuid" select="/database/table[@name='SR']/row[@ref=$sr_ref]/@uuid" />
                    <tr>
  		                 <td><xsl:value-of select="$sr_name"/><br/>(<a href="#SR:{$sr_uuid}"><xsl:value-of select="$sr_uuid"/></a>)</td>
                       <td><xsl:value-of select="@currently_attached"/></td>
                       <td>
                          <xsl:call-template name="format_serial_array">
                             <xsl:with-param name="input_text" select="@device_config"/>
                          </xsl:call-template>
                       </td>
                       <td><xsl:value-of select="@uuid"/></td>
                    </tr>
                 </xsl:for-each>
             </table>
       </xsl:for-each>

       <a name="host_network"/>
       <h2>Physical Network Interfaces</h2>
       <xsl:for-each select="/database/table[@name='host']/row">
               <xsl:sort select="@name__label"/>
               <xsl:variable name="host_ref" select="@ref"/>
               <h3><xsl:value-of select="@name__label"/></h3>
               <table>
                  <tr>
                     <th>Device Name</th>
                     <th>IP Type</th>
                     <th>IP / Subnet</th>
                     <th>DNS</th>
                     <th>Default GW</th>
                     <th>MTU</th>
                     <th>MAC</th>
                     <th>VLAN</th>
                     <th>Network Name (UUID)</th>
                     <th>Currently Attached</th>
                     <th>Used for Mgmnt</th>
                     <th>UUID</th>
                     <th>Device Config</th>
                  </tr>
                  <xsl:for-each select="/database/table[@name='PIF']/row[@host=$host_ref]" >
                     <xsl:sort select="@device_name"/>
                     <xsl:variable name="network_ref" select="@network"/>
                     <xsl:variable name="network_uuid" select="/database/table[@name='network']/row[@ref=$network_ref]/@uuid"/>
                     <tr>
                        <td><xsl:value-of select="@device_name"/></td>
                        <td><xsl:value-of select="@ip_configuration_mode"/></td>
                        <td>
                           <xsl:if test="@ip_configuration_mode!='None'">
                              <xsl:value-of select="@IP"/> / <xsl:value-of select="@netmask"/>
                           </xsl:if>
                        </td>
                        <td><xsl:value-of select="@DNS"/></td>
                        <td><xsl:value-of select="@gateway"/></td>
                        <td><xsl:value-of select="@MTU"/></td>
                        <td><xsl:value-of select="@MAC"/></td>
                        <td>
                           <xsl:choose>
                              <xsl:when test="@VLAN=-1">None/Untagged</xsl:when>
                              <xsl:otherwise><xsl:value-of select="@VLAN"/></xsl:otherwise>
                           </xsl:choose>
                        </td>
                        <td><xsl:value-of select="/database/table[@name='network']/row[@ref=$network_ref]/@name__label"/> (<a href="#NETWORK:{$network_uuid}"><xsl:value-of select="$network_uuid"/></a>)</td>
                        <td><xsl:value-of select="@currently_attached"/></td>
                        <td><xsl:value-of select="@management"/></td>
                        <td><xsl:value-of select="@uuid"/></td>
                        <td>
                          <xsl:call-template name="format_serial_array">
                             <xsl:with-param name="input_text" select="@other_config"/>
                          </xsl:call-template>
                        </td>
                     </tr>
                  </xsl:for-each>
               </table>
           </xsl:for-each>

          <a name="host_network_details"/>
          <h2>Physical Network Interface Details (XenServer 4.x Only)</h2>
          <xsl:for-each select="/database/table[@name='host']/row">
             <xsl:sort select="@name__label"/>
             <xsl:variable name="host_ref" select="@ref"/>
             <h3><xsl:value-of select="@name__label"/></h3>
             <table>
                 <tr>
                     <th>Device Name</th>
                     <th>PCI Bus Path</th>
                     <th>Device ID</th>
                     <th>Vendor ID</th>
                     <th>Vendor Name</th>
                     <th>Device Name</th>
                     <th>Carrier (Link)</th>
                     <th>Speed (Mbps)</th>
                     <th>Duplex</th>
                  </tr>
                  <xsl:for-each select="/database/table[@name='PIF']/row[@host=$host_ref]" >
                     <xsl:sort select="@device_name"/>
                     <xsl:variable name="metrics_ref" select="@metrics"/>
                     <xsl:variable name="device_name" select="@device_name"/>
                  <tr>
                     <xsl:for-each select="/database/table[@name='PIF_metrics']/row[@ref=$metrics_ref]" >
                        <td><xsl:value-of select="$device_name"/></td>
                        <td><xsl:value-of select="@pci_bus_path"/></td>
                        <td><xsl:value-of select="@device_id"/></td>
                        <td><xsl:value-of select="@vendor_id"/></td>
                        <td><xsl:value-of select="@vendor_name"/></td>
                        <td><xsl:value-of select="@device_name"/></td>
                        <td><xsl:value-of select="@carrier"/></td>
                        <td><xsl:value-of select="@speed"/></td>
                        <td>
                           <xsl:choose>
                              <xsl:when test="@duplex='true'">Full</xsl:when>
                              <xsl:when test="@duplex='false' and @carrier='true'">Half</xsl:when>
                              <xsl:otherwise>-</xsl:otherwise>
                           </xsl:choose>
                        </td>
                     </xsl:for-each>
                  </tr>
               </xsl:for-each>
            </table>
         </xsl:for-each>

         <a name="host_patches"/>
         <h2>Patches / Hotfixes</h2>
         <xsl:for-each select="/database/table[@name='host']/row">
         <xsl:sort select="@name__label"/>
             <xsl:variable name="host_ref" select="@ref"/>
             <h3><xsl:value-of select="@name__label"/></h3>
             <table>
                <tr>
                   <th>Name</th>
                   <th>Description</th>
                   <th>Applied</th>
                   <th>Date/Time Applied</th>
                  </tr>
                  <xsl:for-each select="/database/table[@name='host_patch']/row[@host=$host_ref]" >
                    <xsl:sort select="@timestamp_applied"/>                          
                    <xsl:variable name="pool_patch_ref" select="@pool_patch"/>
                    <tr>
                       <xsl:choose>
                          <xsl:when test="$pool_patch_ref!=''">
                             <td><xsl:value-of select="/database/table[@name='pool_patch']/row[@ref=$pool_patch_ref]/@name__label"/></td>
                             <td><xsl:value-of select="/database/table[@name='pool_patch']/row[@ref=$pool_patch_ref]/@name__description"/></td>
                          </xsl:when>
                          <xsl:otherwise>
                             <td><xsl:value-of select="@name__label"/></td>
                             <td><xsl:value-of select="@name__description"/></td>
                          </xsl:otherwise>
                       </xsl:choose>
                       <td><xsl:value-of select="@applied"/></td>
                       <td><xsl:value-of select="@timestamp_applied"/></td>
                    </tr>
                 </xsl:for-each>
             </table>
          </xsl:for-each>

          <a name="vm"/>
          <h1>Virtual Machines</h1>

          <a name="vm_summary"/>
          <h2>Virtual Machine Summary</h2>
          <p>The list below provides a list of XenServer Virtual Machines.</p>
          <table>
             <tr>
                <th>Name</th>
                <th>Description</th>
                <th>Other Configuration</th>
                <th>Number of VCPUs</th>
                <th>RAM</th>
                <th>Shadow Multiplier (1)</th>
                <th>VM UUID</th>
                <th>Status/Running On</th>
                <th>Current DomID</th>
             </tr>
             <xsl:for-each select="/database/table[@name='VM']/row[@is_a_template='false' and @is_control_domain='false']">               
                <xsl:sort select="@name__label"/>
                    <xsl:variable name="resident_on" select="@resident_on"/>
                    <xsl:variable name="host_name" select="/database/table[@name='host']/row[@ref=$resident_on]/@name__label"/>
                    <tr>
                    <td><xsl:value-of select="@name__label"/></td>
                    <td><xsl:value-of select="@name__description"/></td>
                    <td>
                       <xsl:call-template name="format_serial_array">
                          <xsl:with-param name="input_text" select="@other_config"/>
                       </xsl:call-template>
                    </td>
                    <td><xsl:value-of select="@VCPUs__at_startup"/></td>
                    <td><xsl:value-of select="@memory__dynamic_max div 1048576"/>Mb</td>
                    <td><xsl:value-of select="@HVM__shadow_multiplier"/></td>
                    <td><xsl:value-of select="@uuid"/></td>
                    <td><xsl:value-of select="$host_name"/></td>
                    <td>
                       <xsl:choose>
                          <xsl:when test="@domid='-1'">Not running</xsl:when>
                          <xsl:otherwise><xsl:value-of select="@domid"/></xsl:otherwise>
                       </xsl:choose>
                    </td>
                  </tr>
                </xsl:for-each>
          </table>
          <p>Notes:<br/>(1) It's recommended that the Shadow Multiplier is set to 4.000 for Virtual Machines running Citrix XenApp.</p>

          <a name="vm_details"/>
          <h2>Virtual Machine Details</h2>
          <p>The list below provides details of running Virtual Machines. In some cases, this information may represent the last time the Virtual Machine was running.</p>
          <table>
             <tr>
                <th>Virtual Machine</th>
                <th>Operating System</th>
                <th>XenTools Version (1)</th>              
                <th>Networks</th>
                <th>Memory (Bytes)</th>
             </tr>
             <xsl:for-each select="/database/table[@name='VM']/row[@is_a_template='false' and @is_control_domain='false' and @guest_metrics!='OpaqueRef:NULL']">
                <xsl:sort select="@name__label"/>
                <xsl:variable name="guest_metrics" select="@guest_metrics"/>
                <xsl:variable name="vm_name" select="@name__label"/>
                <xsl:for-each select="/database/table[@name='VM_guest_metrics']/row[@ref=$guest_metrics]">
                   <tr>
                       <td><xsl:value-of select="$vm_name"/></td>
                       <td>
                          <xsl:call-template name="format_serial_array">
                             <xsl:with-param name="input_text" select="@os_version"/>
                          </xsl:call-template>
                       </td>
                       <xsl:choose>
                          <xsl:when test="@PV_drivers_up_to_date='true'">
                             <td style="background-color: #00FF00">
                             <xsl:call-template name="format_serial_array">
                                <xsl:with-param name="input_text" select="@PV_drivers_version"/>
                             </xsl:call-template>
                          </td>
                          </xsl:when>
                          <xsl:otherwise>
                             <td style="background-color: #FF0000">
                                <xsl:call-template name="format_serial_array">
                                   <xsl:with-param name="input_text" select="@PV_drivers_version"/>
                                </xsl:call-template>
                             </td>
                          </xsl:otherwise>
                        </xsl:choose>
                        <td>
                          <xsl:call-template name="format_serial_array">
                             <xsl:with-param name="input_text" select="@networks"/>
                          </xsl:call-template>
                       </td>
                        <td>
                          <xsl:call-template name="format_serial_array">
                             <xsl:with-param name="input_text" select="@memory"/>
                          </xsl:call-template>
                       </td>                    
                    </tr>
                    </xsl:for-each>
                 </xsl:for-each>
               </table>
               <p>Notes:<br/>(1) Green: XenTools is up to date, Red: XenTools is not up to date.</p>

               <a name="vbd_details"/>
               <h2>Virtual Block Devices</h2>
               <p>The list below provides details of Virtual Block Devices for each virtual machine.</p>
               <xsl:for-each select="/database/table[@name='VM']/row[@is_a_template='false' and @is_control_domain='false' and @guest_metrics!='OpaqueRef:NULL']">
                  <xsl:sort select="@name__label"/>
                  <xsl:variable name="vm_ref" select="@ref"/>
                  <h3>VBDs on VM '<xsl:value-of select="@name__label"/>'</h3>
                  <table>
                     <tr>
                        <th>Storage Repository</th>
                        <th>Device Order</th>
                        <th>Device Name</th>
                        <th>Mode</th>
                        <th>Type</th>
                        <th>Currently Attached</th>
                        <th>Bootable</th>
                        <th>Location (1)</th>
                     </tr>
                     <xsl:for-each select="/database/table[@name='VBD']/row[@VM=$vm_ref]">
                        <xsl:sort select="@userdevice"/>
                        <xsl:variable name="vdi_ref" select="@VDI"/>
                        <xsl:variable name="sr_ref" select="/database/table[@name='VDI']/row[@ref=$vdi_ref]/@SR" />
                        <xsl:variable name="vdi_location" select="/database/table[@name='VDI']/row[@ref=$vdi_ref]/@location" />
                        <xsl:variable name="sr_name_label" select="/database/table[@name='SR']/row[@ref=$sr_ref]/@name__label" />
                        <xsl:variable name="sr_uuid" select="/database/table[@name='SR']/row[@ref=$sr_ref]/@uuid" />
                        <tr>
                           <td>
                           <xsl:choose>
                              <xsl:when test="@empty='true'">(Empty)</xsl:when>
                              <xsl:otherwise><a href="#SR:{$sr_uuid}"><xsl:value-of select="$sr_name_label"/></a></xsl:otherwise>
                           </xsl:choose>
                           </td>
                           <td><xsl:value-of select="@userdevice"/></td>
                           <td><xsl:value-of select="@device"/></td>
                           <td><xsl:value-of select="@mode"/></td>
                           <td><xsl:value-of select="@type"/></td>
                           <td><xsl:value-of select="@currently_attached"/></td>
                           <td><xsl:value-of select="@bootable"/></td>
                           <td><xsl:value-of select="$vdi_location"/></td>
                        </tr>
                     </xsl:for-each>
                  </table>
               </xsl:for-each>
               <p>Notes:<br/>(1) Location represents the ISO filename (for ISO repositories) or the UUID of the VDI.</p>
       </body>
    </html>
   </xsl:template>

   <xsl:template match="/database/manifest/pair">
      <xsl:value-of select="@value"/>
   </xsl:template>

   <xsl:template match="/database/table/row">
      <xsl:value-of select="."/>
   </xsl:template>

   <xsl:template match="/database/table[@name='pool_patch']/row">
      <tr>
         <td><xsl:value-of select="@name__label"/></td>
         <td><xsl:value-of select="@name__description"/></td>
         <td>
                 <xsl:choose>
                         <xsl:when test="@after_apply_guidance='(&quot;restartHost&quot;)'">Restart Host</xsl:when>
                         <xsl:otherwise><xsl:value-of select="@after_apply_guidance"/></xsl:otherwise>
                 </xsl:choose>
         </td>
      </tr>
   </xsl:template>

   <xsl:template match="/database/table[@name='host']/row">
      <!--XPath expression to capture the iSCSI IQN from the other_config attribute, limited to XSLT 1
     functions -->
      <xsl:variable name="iscsi_iqn"
                select="substring-before(substring-after(@other_config, 'iscsi_iqn&quot; &quot;'), '&quot;))')"/>
      <tr>
         <td><xsl:value-of select="@name__label"/></td>
         <td><xsl:value-of select="@hostname"/></td>
         <td><xsl:value-of select="@name__description"/></td>
         <td><xsl:value-of select="@address"/></td>
         <td><xsl:value-of select="$iscsi_iqn"/></td>
         <td>
            <xsl:call-template name="format_serial_array">
               <xsl:with-param name="input_text" select="@license_params"/>
            </xsl:call-template>
         </td>
         <td><xsl:value-of select="@uuid"/></td>
      </tr>      
   </xsl:template>

   <xsl:template match="/database/table[@name='host_cpu']/row">
      <tr>
         <td><xsl:value-of select="@number"/></td>
         <td><xsl:value-of select="@vendor"/></td>
         <td><xsl:value-of select="@modelname"/></td>
         <td><xsl:value-of select="@model"/></td>
         <td><xsl:value-of select="@stepping"/></td>
         <td><xsl:value-of select="@family"/></td>
         <td><xsl:value-of select="@flags"/></td>
      </tr>
   </xsl:template>

   <xsl:template match="/database/table[@name='host_metrics']/row">
         <!-- Converts bytes to Mb for readability -->
         <td><xsl:value-of select="round(@memory__total div 1048576)"/>Mb</td>
         <td><xsl:value-of select="round(@memory__free div 1048576)"/>Mb</td>
   </xsl:template>

   <xsl:template match="/database/table[@name='SR']/row" >
      <tr>
         <td>
            <xsl:value-of select="@name__label"/>
            <xsl:if test="@shared='false'">
               <xsl:variable name="sr_ref" select="@ref"/>
               <xsl:variable name="host_ref" select="/database/table[@name='PBD']/row[@SR=$sr_ref]/@host"/>
               <xsl:variable name="host_name" select="/database/table[@name='host']/row[@ref=$host_ref]/@name__label"/>
(local on '<xsl:value-of select="$host_name"/>')
            </xsl:if>
          </td>
          <td><xsl:value-of select="@name__description" /></td>
          <td><xsl:value-of select="@shared"/></td>
          <td><xsl:value-of select="@type"/></td>
          <td><xsl:value-of select="@content_type"/></td>
          <td><xsl:value-of select="round(@physical_size div 1048576)"/>Mb</td>
          <td><xsl:value-of select="round(@virtual_allocation div 1048576)"/>Mb</td>
	  <td><a name="SR:{@uuid}"><xsl:value-of select="@uuid"/></a></td>
      </tr>
   </xsl:template>

   <xsl:template match="/database/table[@name='network']/row" >
      <tr>
         <td><xsl:value-of select="@name__label"/></td>
         <td><xsl:value-of select="@name__description" /></td>
         <td><xsl:value-of select="@bridge" /></td>
         <td>
            <xsl:call-template name="format_serial_array">
               <xsl:with-param name="input_text" select="@other_config"/>
            </xsl:call-template>
         </td>
         <td><a name="NETWORK:{@uuid}"><xsl:value-of select="@uuid"/></a></td>
      </tr>
   </xsl:template>

   <!-- Array parsing/formatting functions -->
   <!-- Strip the starting and ending braces -->
   <xsl:template name="format_serial_array">
      <xsl:param name="input_text" />

      <xsl:variable name="serial_len" select="string-length($input_text)" />
      <xsl:variable name="inner_array" select="substring($input_text,2, ($serial_len - 2))" />

      <xsl:call-template name="format_serial_split">
         <xsl:with-param name="input_text" select="$inner_array"/>
      </xsl:call-template>
   </xsl:template>

   <!-- Unserialize the array structure into readable var/val pairs -->
   <xsl:template name="format_serial_split">
        <xsl:param name="input_text" />

        <xsl:variable name="quot">'</xsl:variable>
        <xsl:variable name="quot_space_quot">' '</xsl:variable>
        <xsl:variable name="quot_cb">') </xsl:variable>

        <xsl:variable name="var_begin" select="substring($input_text, 3)" />
        <xsl:variable name="var_end"   select="substring-before($var_begin, $quot)" />

        <xsl:variable name="val_begin" select="substring-after($var_begin, $quot_space_quot)" />
        <xsl:variable name="val_end" select="substring-before($val_begin, $quot_cb)" />

        <xsl:variable name="str_rem" select="substring-after($input_text, $quot_cb)" />
        
        <xsl:if test="string-length($var_end) > 0">
           <b><xsl:value-of select="$var_end"/>: </b><xsl:value-of select="$val_end"/><br/>
        </xsl:if>

        <xsl:if test="string-length($str_rem) > 0">
           <xsl:call-template name="format_serial_split">
              <xsl:with-param name="input_text" select="$str_rem" />
           </xsl:call-template>      
        </xsl:if>
   </xsl:template>
</xsl:stylesheet>
