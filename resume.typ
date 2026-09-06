// ---------------------------------------------------------------------
// This file renders BOTH résumé PDFs from _data/resume.yml — the same
// file resume.html reads to build the website page. Edit content only
// in _data/resume.yml; this file is presentation/layout only.
//
// A GitHub Action (.github/workflows/render-resume.yml) recompiles both
// PDFs automatically whenever resume.yml or resume.typ changes, and
// commits them to assets/. You should never need to run this by hand.
//
// Manual use, if you ever want it:
//   typst compile resume.typ assets/James-Bruce-Resume.pdf --input mode=short
//   typst compile resume.typ assets/James-Bruce-Resume-Full.pdf --input mode=full
// ---------------------------------------------------------------------
#let mode = sys.inputs.at("mode", default: "short")
#let full = mode == "full"

#let data = yaml("_data/resume.yml")
#let contact = data.contact

#set text(font: "arial", size: 11pt)
#set page(margin: (x: 0.6in, y: 0.5in))

#block(below: 1em)[
  #text(font: "arial", size: 25pt, weight: "bold")[#contact.name]
]

#contact.phone
| #link("mailto:" + contact.email)[#contact.email]
| #link(contact.linkedin_url)[#contact.linkedin_display]
| #link(contact.site_url)[#contact.site_display]

#show heading.where(level: 1): it => block(above: 1.2em, below: 1em)[
  #text(size: 11pt, weight: "regular", underline(it.body))
]

#set list(indent: 1.4em, spacing: 0.9em)

// ---------------------------------------------------------------------
// entry(): renders one résumé item (education or experience) from a
// dictionary shaped like the YAML: title/degree, org, date, bullets,
// and an optional full_only flag. Hidden entirely in short mode when
// full_only is true — matching resume.html's exact same logic.
// ---------------------------------------------------------------------
#let entry(item) = {
  if full or not item.at("full_only", default: false) {
    let heading-text = item.at("title", default: item.at("degree", default: ""))
    block(above: 1em, below: 0.4em, breakable: false)[
      #text(size: 10.5pt)[
        *#heading-text* #h(1fr) _ #item.date _ \
        #item.org
      ]
      #list(..item.bullets.map(b => [#b]))
    ]
  }
}

= EDUCATION

#for edu in data.education [
  #entry(edu)
]

#if "coursework" in data and full [
  #block(above: 0.6em, below: 0.4em)[
    *Relevant Coursework:* #data.coursework.join(", ")
  ]
]

= SKILLS

#for group in data.skills [
  *#group.group:* #group.items.join(", ")

]

= WORK & VOLUNTEER EXPERIENCE

#for job in data.experience [
  #entry(job)
]
