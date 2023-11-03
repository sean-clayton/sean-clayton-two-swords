#let title = "White Wolf"

#let highlight-color = luma(90%)

#let set-page-numbers() = {
  locate(loc => {
    set text(size: 10pt)

    let page-number = [
      #circle(radius: 0.8em, fill: highlight-color)[
        #set align(center + horizon)
        #counter(page).display("1")
      ]
    ]
    if (calc.even(loc.page())) [
      #set align(left)
      #page-number
    ] else [
      #set align(right)
      #page-number
    ]
  })
}

#let load-stat(filename) = {
  yaml("stats/" + filename + ".yaml")
}

#let chapter-heading(..args, content) = {
  show heading: set text(size: 24pt)
  heading(..args)[#content]
}

#let section-heading(..args, content) = {
  show heading: set text(size: 18pt)
  heading(..args)[#content]
}

#let section-sub-heading(..args, content) = {
  show heading: set text(size: 12pt)

  box(fill: highlight-color, inset: (x: 4pt, y: 6pt), width: 100%)[
    #heading(..args)[#content]
  ]
}

#let wrapper(doc) = [
  #set document(title: title)

  #set page(width: 170mm, height: 240mm, margin: (bottom: 2cm, x: 1cm, top: 1cm))

  #set text(font: "Gentium Book Plus", size: 10pt)

  #show heading: it => {
    set text(font: "Rosario")
    it
  }

  #show link: it => {
    set text(weight: "bold")

    underline(it)
  }

  #show outline.entry.where(level: 1): it => {
    v(12pt, weak: true)
    strong(it)
  }

  #doc
]

#let cairn-stat-block(data, preamble) = {
  let escape-str(str) = str.replace("\\", "\\\\").replace("#", "\#")
  let markup-eval(str) = eval(escape-str(str), mode: "markup")

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

  set list(tight: true)

  block(breakable: false)[
    #preamble

    #stat-line
    #for detail in details [
      - #markup-eval(detail)
    ]
    #if critical-damage != none [
      - *Critical Damage:* #critical-damage
    ]
  ]
}