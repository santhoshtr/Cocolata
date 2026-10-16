# Cocolata Malayalam Typeface

A handwriting-style variable typeface for Malayalam and Latin.

Cocolata (കോക്കലാറ്റ) is a variable font with one axis, weight. One font file contains all weights from Thin (100) to Black (900). The font also has 9 *named instances*¹. Font menus show these as usual styles: Thin, ExtraLight, Light, Regular, Medium, SemiBold, Bold, ExtraBold and Black.

¹ *Named instance*: a fixed location in the design space of a variable font. It works like a static font style.

The glyphs are not drawn by hand. MetaPost programs describe each glyph with parameters. A build tool then makes the font from these programs.

## Variation axes

| Axis   | Tag    | Range      | Default | Description                                        |
| ------ | ------ | ---------- | ------- | -------------------------------------------------- |
| Weight | `wght` | 100 to 900 | 400     | Thin to Black. Use the usual `font-weight` property. |

## OpenType features

* Malayalam conjuncts, reph forms, La-conjuncts and stacked u/uu forms.
* Chillu letters, also from the virama + ZWJ sequence.
* `calt`: contextual alternates. Some repeated letters change their shape, as in handwriting.
* `salt`: stylistic alternates for some Latin and Malayalam letters.
* `liga`: Latin ligatures ff and ft. `<3` gives a heart.
* `sups`: superior figures ¹ ² ³.
* `kern`: kerning for Latin and Malayalam.

## Using the fonts

* Download the latest fonts from the [Releases](https://gitlab.com/smc/fonts/Cocolata/-/releases/). Look under the "Assets" of the latest release, download the zip, and then open that zip.
* Install the fonts on your system. The installation steps are different for each operating system. Usually, when you click the font file, you get an option to install it.

### Using the variable font in web pages

A variable font saves bandwidth on web pages: you download one file and you get all weights. For a full guide, see the [MDN variable fonts guide](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_fonts/Variable_fonts_guide).

Link the font with `@font-face`:

```css
@font-face {
 font-family: 'Cocolata';
 src: url('path/to/font/Cocolata-variable.woff2') format('woff2');
 font-weight: 100 900;
}
```

Then use the font with `font-weight` or `font-variation-settings`. [CSS custom properties](https://pixelambacht.nl/2019/fixing-variable-font-inheritance/) help to avoid some problems with property inheritance.

## Building the fonts

The build needs these tools:

* Rust and Cargo (see `rust-version` in `Cargo.toml`)
* `mpost` from TeX Live (`texlive-metapost` on Debian)
* [`fontc`](https://github.com/googlefonts/fontc)
* `hb-view` (`libharfbuzz-bin`), `ots-sanitize` and [`fontspector`](https://github.com/fonttools/fontspector), for proofs and tests only

The devcontainer in `.devcontainer/` installs all of these.

To build everything, run make:

```bash
make
```

A full build takes about 15 minutes. On a computer with more processors, a parallel build is faster. For example, on a computer with 8 CPUs:

```bash
make -j8
```

The fonts are in the `fonts` directory.

## Language support

The font has all the characters of the Malayalam block in Unicode. Cocolata also supports the Latin script. Cocolata supports 294 languages, with approximately 2.8 billion speakers (calculated with the [hyperglot tool](https://hyperglot.rosettatype.com/)).

<details>
  <summary><strong>Supported languages</strong></summary>
  <ul>
    <li> Acheron </li>
    <li> Achinese </li>
    <li> Acholi </li>
    <li> Afar </li>
    <li> Afrikaans </li>
    <li> Alekano </li>
    <li> Aleut </li>
    <li> Amahuaca </li>
    <li> Amarakaeri </li>
    <li> Amis </li>
    <li> Anaang </li>
    <li> Andaandi, Dongolawi </li>
    <li> Anuta </li>
    <li> Ao Naga </li>
    <li> Aragonese </li>
    <li> Arbëreshë Albanian </li>
    <li> Arvanitika Albanian </li>
    <li> Asháninka </li>
    <li> Ashéninka Perené </li>
    <li> Asu (Tanzania) </li>
    <li> Balinese </li>
    <li> Bari </li>
    <li> Basque </li>
    <li> Batak Dairi </li>
    <li> Batak Karo </li>
    <li> Batak Mandailing </li>
    <li> Batak Simalungun </li>
    <li> Batak Toba </li>
    <li> Bemba (Zambia) </li>
    <li> Bena (Tanzania) </li>
    <li> Bikol </li>
    <li> Bislama </li>
    <li> Borana-Arsi-Guji Oromo </li>
    <li> Bosnian </li>
    <li> Breton </li>
    <li> Buginese </li>
    <li> Candoshi-Shapra </li>
    <li> Caquinte </li>
    <li> Caribbean Hindustani </li>
    <li> Cashibo-Cacataibo </li>
    <li> Catalan </li>
    <li> Cebuano </li>
    <li> Central Aymara </li>
    <li> Central Kurdish </li>
    <li> Chamorro </li>
    <li> Chavacano </li>
    <li> Chiga </li>
    <li> Chiltepec Chinantec </li>
    <li> Chokwe </li>
    <li> Chuukese </li>
    <li> Cimbrian </li>
    <li> Cofán </li>
    <li> Congo Swahili </li>
    <li> Cook Islands Māori </li>
    <li> Cornish </li>
    <li> Corsican </li>
    <li> Creek </li>
    <li> Crimean Tatar </li>
    <li> Croatian </li>
    <li> Czech </li>
    <li> Danish </li>
    <li> Dehu </li>
    <li> Dutch </li>
    <li> Eastern Abnaki </li>
    <li> Eastern Arrernte </li>
    <li> Eastern Oromo </li>
    <li> Embu </li>
    <li> English </li>
    <li> Ese Ejja </li>
    <li> Faroese </li>
    <li> Fijian </li>
    <li> Filipino </li>
    <li> Finnish </li>
    <li> French </li>
    <li> Friulian </li>
    <li> Galician </li>
    <li> Ganda </li>
    <li> Garifuna </li>
    <li> Ga’anda </li>
    <li> German </li>
    <li> Gheg Albanian </li>
    <li> Gilbertese </li>
    <li> Gooniyandi </li>
    <li> Gourmanchéma </li>
    <li> Guadeloupean Creole French </li>
    <li> Gusii </li>
    <li> Haitian </li>
    <li> Hani </li>
    <li> Hawaiian </li>
    <li> Hiligaynon </li>
    <li> Ho-Chunk </li>
    <li> Hopi </li>
    <li> Huastec </li>
    <li> Hungarian </li>
    <li> Hän </li>
    <li> Icelandic </li>
    <li> Iloko </li>
    <li> Inari Sami </li>
    <li> Indonesian </li>
    <li> Irish </li>
    <li> Istro Romanian </li>
    <li> Italian </li>
    <li> Ixcatlán Mazatec </li>
    <li> Jamaican Creole English </li>
    <li> Japanese </li>
    <li> Javanese </li>
    <li> Jola-Fonyi </li>
    <li> K'iche' </li>
    <li> Kabuverdianu </li>
    <li> Kalaallisut </li>
    <li> Kalenjin </li>
    <li> Kamba (Kenya) </li>
    <li> Kaonde </li>
    <li> Karelian </li>
    <li> Kashubian </li>
    <li> Kekchí </li>
    <li> Kenzi, Mattokki </li>
    <li> Khasi </li>
    <li> Kikuyu </li>
    <li> Kimbundu </li>
    <li> Kinyarwanda </li>
    <li> Kituba (DRC) </li>
    <li> Kongo </li>
    <li> Konzo </li>
    <li> Kuanyama </li>
    <li> Kven Finnish </li>
    <li> Kölsch </li>
    <li> Ladin </li>
    <li> Ladino </li>
    <li> Latgalian </li>
    <li> Latin </li>
    <li> Ligurian </li>
    <li> Lithuanian </li>
    <li> Lombard </li>
    <li> Low German </li>
    <li> Lower Sorbian </li>
    <li> Luba-Lulua </li>
    <li> Lule Sami </li>
    <li> Luo (Kenya and Tanzania) </li>
    <li> Luxembourgish </li>
    <li> Macedo-Romanian </li>
    <li> Makhuwa </li>
    <li> Makhuwa-Meetto </li>
    <li> Makonde </li>
    <li> Makwe </li>
    <li> Malagasy </li>
    <li> Malaysian </li>
    <li> Maltese </li>
    <li> Mandinka </li>
    <li> Manx </li>
    <li> Maore Comorian </li>
    <li> Maori </li>
    <li> Mapudungun </li>
    <li> Marshallese </li>
    <li> Matsés </li>
    <li> Mauritian Creole </li>
    <li> Meriam Mir </li>
    <li> Meru </li>
    <li> Minangkabau </li>
    <li> Mirandese </li>
    <li> Mohawk </li>
    <li> Montenegrin </li>
    <li> Munsee </li>
    <li> Murrinh-Patha </li>
    <li> Mwani </li>
    <li> Mískito </li>
    <li> Naga Pidgin </li>
    <li> Ndonga </li>
    <li> Neapolitan </li>
    <li> Ngazidja Comorian </li>
    <li> Niuean </li>
    <li> Nobiin </li>
    <li> Nomatsiguenga </li>
    <li> North Marquesan </li>
    <li> North Ndebele </li>
    <li> Northern Kurdish </li>
    <li> Northern Qiandong Miao </li>
    <li> Northern Uzbek </li>
    <li> Norwegian </li>
    <li> Nyanja </li>
    <li> Nyankole </li>
    <li> Occitan </li>
    <li> Ojitlán Chinantec </li>
    <li> Orma </li>
    <li> Oroqen </li>
    <li> Palauan </li>
    <li> Paluan </li>
    <li> Pampanga </li>
    <li> Papantla Totonac </li>
    <li> Papiamento </li>
    <li> Pedi </li>
    <li> Picard </li>
    <li> Pichis Ashéninka </li>
    <li> Piemontese </li>
    <li> Pijin </li>
    <li> Pintupi-Luritja </li>
    <li> Pipil </li>
    <li> Pohnpeian </li>
    <li> Polish </li>
    <li> Portuguese </li>
    <li> Potawatomi </li>
    <li> Purepecha </li>
    <li> Quechua </li>
    <li> Romanian </li>
    <li> Romansh </li>
    <li> Rotokas </li>
    <li> Rundi </li>
    <li> Rwa </li>
    <li> Samburu </li>
    <li> Samoan </li>
    <li> Sango </li>
    <li> Sangu (Tanzania) </li>
    <li> Saramaccan </li>
    <li> Sardinian </li>
    <li> Scottish Gaelic </li>
    <li> Sena </li>
    <li> Seri </li>
    <li> Seselwa Creole French </li>
    <li> Shambala </li>
    <li> Shawnee </li>
    <li> Shipibo-Conibo </li>
    <li> Shona </li>
    <li> Sicilian </li>
    <li> Silesian </li>
    <li> Slovak </li>
    <li> Slovenian </li>
    <li> Soga </li>
    <li> Somali </li>
    <li> Soninke </li>
    <li> South Marquesan </li>
    <li> South Ndebele </li>
    <li> Southern Aymara </li>
    <li> Southern Qiandong Miao </li>
    <li> Southern Sami </li>
    <li> Southern Sotho </li>
    <li> Spanish </li>
    <li> Sranan Tongo </li>
    <li> Standard Estonian </li>
    <li> Standard Latvian </li>
    <li> Standard Malay </li>
    <li> Sundanese </li>
    <li> Swahili </li>
    <li> Swati </li>
    <li> Swedish </li>
    <li> Swiss German </li>
    <li> Tagalog </li>
    <li> Tahitian </li>
    <li> Taita </li>
    <li> Tedim Chin </li>
    <li> Tetum </li>
    <li> Tetun Dili </li>
    <li> Tiv </li>
    <li> Tok Pisin </li>
    <li> Tokelau </li>
    <li> Tonga (Tonga Islands) </li>
    <li> Tonga (Zambia) </li>
    <li> Tosk Albanian </li>
    <li> Tsonga </li>
    <li> Tswana </li>
    <li> Tumbuka </li>
    <li> Turkish </li>
    <li> Turkmen </li>
    <li> Tzeltal </li>
    <li> Tzotzil </li>
    <li> Uab Meto </li>
    <li> Upper Guinea Crioulo </li>
    <li> Upper Sorbian </li>
    <li> Venetian </li>
    <li> Veps </li>
    <li> Võro </li>
    <li> Wallisian </li>
    <li> Walloon </li>
    <li> Walser </li>
    <li> Wangaaybuwan-Ngiyambaa </li>
    <li> Waray (Philippines) </li>
    <li> Warlpiri </li>
    <li> Wayuu </li>
    <li> Welsh </li>
    <li> West Central Oromo </li>
    <li> Western Abnaki </li>
    <li> Western Frisian </li>
    <li> Wik-Mungkan </li>
    <li> Wiradjuri </li>
    <li> Wolof </li>
    <li> Xhosa </li>
    <li> Yanesha' </li>
    <li> Yao </li>
    <li> Yapese </li>
    <li> Yindjibarndi </li>
    <li> Yucateco </li>
    <li> Zapotec </li>
    <li> Zulu </li>
    <li> Záparo </li>
</ul>
</details>



## Credits

See [FONTLOG.md](FONTLOG.md) for details on contributions.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for policies around contributing to the project.

## License

This Font Software is licensed under the SIL Open Font License, Version 1.1. This license is available with a FAQ at: https://openfontlicense.org
