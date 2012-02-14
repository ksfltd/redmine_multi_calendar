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

class CreateCalendarVacations < ActiveRecord::Migration
  def self.up
    create_table :calendar_vacations do |t|
      t.column :calendar_id, :integer

      t.column :holiday, :string

      t.column :date_holiday, :date

      t.column :fixed_date, :integer, :default => 1

      t.column :pattern_weekly_id, :integer
    end
  end

  def self.down
    drop_table :calendar_vacations
  end
end
