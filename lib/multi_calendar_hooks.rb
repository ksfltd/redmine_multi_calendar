# Redmine Multicalendar plugin - multiple, customizable calendars
# Copyright (C) 2011  KSF Technologies http://ksfltd.com
# Authors: Anna Yalagina, Eugene Hutorny
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; version 2
# of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA

# This class hooks into Redmine's View Listeners in order to add content to the page
class MultiCalendarHooks < Redmine::Hook::ViewListener
   
   

    def view_layouts_base_html_head(context = {})

      css_calendar = stylesheet_link_tag 'blue.css', :plugin => 'redmine_multi_calendar'
      css_calendar_facebox = stylesheet_link_tag 'facebox.css', :plugin => 'redmine_multi_calendar'
      css_multi_calendar = stylesheet_link_tag 'multi_calendar.css', :plugin => 'redmine_multi_calendar'

    

      snippet = ''
     
     snippet += javascript_include_tag 'jquery-1.7.min.js', :plugin => 'redmine_multi_calendar'
      snippet += <<-generatedscript
                <script type="text/javascript">
                var $j = jQuery.noConflict();
                $j(document).ready(function() {
                });
                </script>
                generatedscript

      snippet += javascript_include_tag 'facebox.js', :plugin => 'redmine_multi_calendar'
      snippet += javascript_include_tag 'iColorPicker.js', :plugin => 'redmine_multi_calendar'
      snippet += javascript_include_tag 'multi_calendar.js', :plugin => 'redmine_multi_calendar'
      
      
      snippet = snippet + css_calendar + css_calendar_facebox + css_multi_calendar #+ css_tool_tip
      
        return snippet

    end
end

