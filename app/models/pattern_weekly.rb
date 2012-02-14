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

class PatternWeekly < ActiveRecord::Base
  unloadable

  belongs_to :calendar
  has_many :week_days
  has_many :calendar_vacations

  validates_presence_of :name, :color
  validates_format_of :name, :with => /^[^\'\"\%]*$/i
  validates_format_of :color, :with => /^(#[0-9A-F]{6}|#[0-9A-F]{3}|black|white|blue|red|yellow|green|purple|gray|silver|navy|fuchsia|lime|maroon|olive|teal)$/i

  named_scope :type, lambda { |calendar, name| {:conditions => ["calendar_id = ? AND name = ?", calendar.id, name]} }


  private

  def before_save
    self.duration = 0 if !self.duration
  end


end
