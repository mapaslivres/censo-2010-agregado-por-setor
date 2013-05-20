# encoding: utf-8
require 'rubygems'
require 'fileutils'
require 'csv'
require 'roo'

# Para renomear as extensões
# for file in `ls *.XLS`; do mv $file `basename $file .XLS`.xls; done 

def read_column_types(filename)
  csv_text = File.read(filename)
  csv = CSV.parse(csv_text, :headers => false)
  csv[0]
end

def typecast(value, type)
  if value.nil? then
    ''
  else
    case type
      when 'Integer' then value.to_i
      when 'Real' then value.class.name == 'Float' ? value : value.sub(',','.').to_f
      when 'String' then value.to_s
      else raise 'Tipo não encontrado: ' + type
    end
  end
end

Dir['./Base*/'].each do |source_dir|
  
  # UF do diretório de onde se estão lendo os dados
  uf      = source_dir.split.last.delete('/')
  uf_dir  = './' + uf
  
  # Cria diretório destino
  Dir.mkdir(uf_dir) unless File.exists?(uf_dir)
  
  # Interpreta arquivos da UF
  Dir.glob( source_dir + 'EXCEL/*.xls', File::FNM_CASEFOLD ) do |source_file|
    
    
    basename = File.basename(source_file)[0..-5] # Basename sem a extensão
    csv_filename  = uf_dir + '/' + basename + '.csv'
    csvt_filename = uf_dir + '/' + basename + '.csvt'
    csvt_template_file = './csvt/' + basename.split('_').first + '_UF.csvt'
    
    puts "Gravando " + csvt_filename
    
    # Cria arquivo .csvt com os tipos dos campos
    FileUtils.copy(csvt_template_file, csvt_filename) unless File.exists?(csvt_filename)

    puts "Gravando " + csv_filename

    # abre arquivo csv
    CSV.open(csv_filename, "w") do |csv|
      # abre arquivo xls
      xls = Roo::Spreadsheet.open(source_file)

      # carrega primeira table, onde estão os dados
      sheet    = xls.sheet(0)

      # conta número de colunas e linhas
      row_count     = sheet.last_row
      column_count  = sheet.last_column

      # lê tipos das colunas
      column_types = read_column_types(csvt_filename)

      # grava primeira linha no csv, com os nomes dos campos
      header_names = []  
      1.upto(column_count) do |column|
        header_names << sheet.cell(1,column)
      end

      csv << header_names

      # lê os dados
      2.upto(row_count) do |row|
        values = []
        1.upto(column_count) do |column|
          values << typecast(sheet.cell(row, column), column_types[column - 1])
        end
        csv << values
      end
    end
    

    
  end
  
end