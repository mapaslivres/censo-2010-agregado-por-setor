# Introdução

O IBGE disponibiliza em seu FTP diversos arquivos sobre o Censo 2010, entre eles o resultado do universo agregado por setores censitários. Os formatos disponíveis são Excel (.xls) e Valores Separados por Vírgula (.csv).

Os arquivos .csv disponíveis no FTP estão com um erro de identificação de setores que os torna inutilizáveis. O script disponível neste repositório converte os arquivos Excel para CSV, resolvendo este problema. Adicionalmente, o script gera arquivos .csvt, que identifica os tipos de cada campo, evitando que um programa confunda um tipo inteiro com um real, por exemplo. Veja este [tutorial](http://qgis.spatialthoughts.com/2012/03/using-tabular-data-in-qgis.html) para saber como utilizar este tipo de arquivo no Quantum GIS. 

## Preparando a execução do script

Clone este repositório em um diretório local do seu computador. 

Este script é feito em Ruby. Instale as gems necessárias para executá-lo:

    gem install fileutils csv roo

## Baixando os arquivos de origem

Os arquivos do origem podem ser acessados neste [link](ftp://ftp.ibge.gov.br/Censos/Censo_Demografico_2010/Resultados_do_Universo/Agregados_por_Setores_Censitarios/).

Eles estão separados por unidade federativa, sendo que São Paulo está também dividido entre capital e demais cidades. 

Baixe e descompacte os arquivos a serem interpretados para a pasta que você criou no seu computador.

## Executando o script

Assegure-se de que o conteúdo dos arquivos descompactados estarão em um diretório com o nome do arquivo.

Rode:

    ruby interpretar.rb
    
O script irá criar um novo diretório para cada arquivo Unidade Federativa interpretado, com os resultados gerados.
