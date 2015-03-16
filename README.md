# Teleinfo

[![Build Status](https://travis-ci.org/ook/teleinfo.svg?branch=master)](https://travis-ci.org/ook/teleinfo)
[![Gem Version](https://badge.fury.io/rb/teleinfo.svg)](http://badge.fury.io/rb/teleinfo)

## English:
It's a simple parser for "téléinfo", the data stream available on french electric meters since the 2000.
Data are available as modulations (1200 bauds) on 2 wires directly on the meter. It provides plenty of
interesting informations: meter identification, subscribed power, subscribed contract, immediate power
 consumption, etc.
Since this program concern a french only device, the other documentation will be redacted in french.

## Français :
Il s'agit d'un simple interpréteur de trames téléinfo EDF. Ce programme est testé sur un Raspberry Pi B.
Il permet de déchiffrer chaque trame et en fournir une représentation simple à traiter.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'teleinfo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install teleinfo

## Usage

You can use the binary embedded into the gem: teleinfo <file> (were file can be a regular file containing raw teleinfo datas or STDIN)

On my side, I mounted on my Rasperry Pi a /dev/ttyAMA0 according the instructions from http://www.magdiblog.fr/gpio/teleinfo-edf-suivi-conso-de-votre-compteur-electrique/
So I just run:

    $ teleinfo /dev/ttyAMA0

or 

    $ cat /dev/ttyAMA0 | teleinfo

You'll get on stdout a Hash representation like:

    {"adco":"424242424242","optarif":"HC","isousc":30,"hchc":25036224,"hchp":40244232,"ptec":"HP","iinst":16,"imax":41,"papp":3580,"hhphc":"D"}

Since I have only a counter with HPHC option, feel free to send me a dump of your counter if you want I handle your options set (please create an issue for it).

## Contributing

1. Fork it ( https://github.com/ook/teleinfo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
