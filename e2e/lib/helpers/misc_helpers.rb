# frozen_string_literal: true

module Helpers
  def self.table_to_hash(table)
    table.transpose.raw.each_with_object({}) do |column, hash|
      column.reject!(&:empty?)
      hash[column.shift.to_sym] = column
    end
  end

  # TODO: Move this to better name
  def directory_name(file_name)
    FileUtils.move("#{Nenv.download_dir}#{file_name}.xls", Dir.pwd + '/files')
  end

  def spreadsheet_verify(file, sheet_name)
    special_book = Spreadsheet.open "#{Dir.pwd}/files/#{file}.xls"
    begin
      special_sheet = special_book.worksheet sheet_name.to_s
      num_rows = special_sheet.rows.count
    rescue Exception => ex
      special_sheet = special_book.worksheet sheet_name.to_s
      num_rows = special_sheet.rows.count
    end
    puts "Read #{num_rows} rows"
    special_book.io.close
    num_rows
  end

  def remove_file_special(remove_file)
    FileUtils.rm(Dir.pwd + "/files/#{remove_file}.xls")
  end
end
