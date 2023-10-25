#let title = "White Wolf"

#let wrapper(doc) = [
  #set document(title: title)

  #set page(width: 170mm, height: 240mm, margin: 40pt, numbering: "1")

  #set text(font: "Crimson Pro", size: 9pt)

  #show heading: it => {
    set text(font: "EB Garamond")
    
    it
  }

  #show link: it => {
    set text(weight: "bold")

    underline(it)
  }

  #show outline.entry.where(
    level: 1
  ): it => {
    set text(font: "EB Garamond")
    v(12pt, weak: true)
    strong(it)
  }

  #set align(center)

  #text(size: 24pt, weight: "bold", font: "EB Garamond")[#title]

  #set align(start)

  A dark fantasy setting conversion, created by #link("https://sean.wtf")[Sean-Patrick Ortencio Clayton]. \
  Made for #link("https://cairnrpg.com")[Cairn] by #link("https://newschoolrevolution.com/")[Yochai Gal]. \
  Available under the
  #link(
    "https://creativecommons.org/licenses/by-sa/4.0/",
  )[Creative Commons Attribution-ShareAlike 4.0 International license].

  #outline(indent: 8pt, title: "Table of Contents")

  #pagebreak()

  #doc
]

#let escape-str(str) = str.replace("\\", "\\\\").replace("#", "\#")
#let markup-eval(str) = eval(escape-str(str), mode: "markup")

#let cairn-stat-block(data, title: []) = {
  let hp = data.at("hp", default: 0)
  let armor = data.at("armor", default: 0)
  let str = data.at("str", default: 10)
  let dex = data.at("dex", default: 10)
  let wil = data.at("wil", default: 10)
  let attacks = data.at("attacks", default: ()).join(", ")
  let special = data.at("special", default: none)
  let details = data.at("details", default: ())
  let critical-damage = data.at("critical_damage", default: none)
  let traits = data.at("traits", default: ())

  let attrs = (
    if str != 10 [#str STR] else { none },
    if (dex != 10) [#dex DEX] else { none },
    if (wil != 10) [#wil WIL] else { none },
  ).filter(el => el != none).join(", ")

  let stat-line = (
    if hp != 0 [#hp HP] else { none },
    if armor != 0 [#armor Armor] else { none },
    if attrs != none [#attrs] else { none },
    if attacks != none {
      for attack in attacks {
        attack
      }
    },
    if special != none { markup-eval(special) } else { none },
    for trait in traits {
      trait
    },
  ).filter(el => el != none).join(", ")

  block(breakable: false)[
    #title
    #stat-line
    #for detail in details [
      - #markup-eval(detail)
    ]
    #if critical-damage != none [
      - *Critical Damage:* #critical-damage
    ]
  ]
}