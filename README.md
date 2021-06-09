# bugs-report

### Como funciona

Deve-se passar um array de hash que representa os bugs para o método process_bugs, e o resultado será o print de um relatório com bugs agrupados em listas que a soma das estimas sejam de no máximo 8 horas.

Internamente, o primiero passo é separar apenas os bugs Críticos da lista original de bugs. Após isso os bugs Críticos são processados para que sejam separados em listas contendo bugs em que a soma de suas estimativas sejam de no máximo 8 horas.

### Rodar script
```ruby
$ irb -I
irb(main):002:0> require_relative './src/prioritizer'
=> true
irb(main):003:0> require 'json'
=> true
irb(main):004:0> bugs_file = File.open( File.join(File.dirname(__FILE__), './test/bugs.json'), 'r+' )
irb(main):005:0> bugs = JSON.parse(bugs_file.read).map{|hash| hash.transform_keys(&:to_sym) }
irb(main):006:0> prioritizer = Prioritizer.new
irb(main):007:0> prioritizer.process_bugs bugs
```

### Rodar testes
```bash
$ rspec test/prioritizer_spec.rb
```