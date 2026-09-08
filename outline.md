# Specialty UMAP — Read This First: How AI Makes a Map of Medical Specialties

Specialty UMAP uses **artificial intelligence** to help people explore medical
specialties and discover groups with similar characteristics. You can describe
the kind of working life you are looking for and see which group the model
suggests exploring. But how can a medical specialty have a place on a map?
Let us start with a meeting.

## 1. Where shall we meet?

Imagine arranging to meet someone in a town. Where should they look? Naming a
mall helps, but there are still shops, corridors, bathrooms, and parking lots
to search. Naming a restaurant makes finding you much easier. Each step leaves
fewer places to look.

Now imagine narrowing the meeting place until it has no separate parts in which
you could still miss each other. That is the idea behind Euclid's definition:
“A point is that which has no part.” A point gives a position without taking up
space. The dot we draw to mark it has size; the point it represents does not.

We owe this teaching insight to the late David W. Henderson, a mathematics
professor at Cornell. It brings an idea from ancient geometry into something
as ordinary as meeting a friend for lunch.

## 2. Descartes gives us numbers

Euclid helps us explain **what a point is**. Descartes helps us explain **how many numbers can specify its position**.

“Many” also prepares the reader for the transition from two or three coordinates
to the many measurements that describe a medical specialty.

You may know René Descartes for “I think, therefore I am.” He also helped bring
geometry and numbers together. The Cartesian coordinates named after him let
us describe a position with numbers.

Think of finding your seat in a theater: row 5, seat 12. Two numbers tell you
where to go. On paper, two numbers can similarly tell us how far across and how
far up to mark a point. In a room, we also need its height. That takes three.

## 3. What numbers describe a medical specialty?

Height and weight describe a person. Each property is a **feature**. If we draw
height across a sheet and weight up the sheet, each person has a place where
we can put a dot. People with similar measurements appear near each other.

Medical specialties have features too. How many years of training are required?
How much does the work involve procedures? How prominent is research? What is
the typical pay? These are useful things to compare when thinking about a career.

Specialty UMAP describes 143 specialty and subspecialty categories using nine
features: training duration, procedural work, scientific activity, private
practice, competition for training places, clinical work intensity, salary,
physician availability relative to patient burden, and female representation.
Some figures are estimates inherited from broader specialty categories, so
the descriptions are more approximate than a personal account of a particular job.

Together, nine numbers give each specialty a position in a space with nine
dimensions. That simply means we describe it in nine different ways.
**Feature space** is the mathematical name for this space of descriptions.

## 4. Why make a map?

We can picture a sheet of paper or a room. We cannot picture nine independent
directions at once. A map gives our eyes something to follow and our minds
something to work with.

People have been doing related things for centuries. A photographer puts a view
of a three-dimensional street onto a flat photograph. An architect draws how a
room will look. A painter uses perspective to suggest depth on a flat canvas.
These are familiar examples of **projection**: making a flat representation of
something that is not flat.

Mapmakers face the curved Earth. Mercator, Lambert, and Albers gave their names
to different ways of putting it onto paper. Some maps preserve relative areas;
others favor different relationships. Think of flattening an orange peel: it
will not spread neatly without tearing or stretching.

A map of specialties faces a similar tradeoff. Its mathematics differs from a
geographic projection, but its purpose is familiar: make complicated
relationships visible while preserving the ones we care about most.

## 5. A neighborhood of specialties

UMAP is the method this project uses to draw the picture. It tries to put
specialties with similar measurements near each other. We can then explore
neighborhoods: perhaps specialties with longer training or more procedural work.

Such a group is called a **cluster**. A method named DBSCAN finds groups of
points gathered together. Their descriptions reflect the measurements that
stand out within each group. Some specialties may fall outside any group.

The picture simplifies things. Two nearby dots are an invitation to compare
the specialties more closely, rather than proof that their daily work is identical.

## 6. AI explores possibilities: AWRS-SMC

Should training duration matter more than salary when making the map? What
happens if we give more importance to research? AWRS-SMC explores different
choices about how the map is made.

The easiest part of its name to remember is **Monte Carlo**, the place famous
for its casino. Monte Carlo methods use random trials to explore possibilities.
The computer tries different choices, checks their results, and gives more
attention to promising candidates. It can try far more combinations than we
would want to work through by hand.

In this project's recorded search, none of the sampled alternatives scored
better than the reference recipe. The reference map remains available alongside
an alternative and a comparison page. Searching is useful even when the answer
is that the original choice worked better in the trials performed.

## 7. AI learns from exercises

The project also trains a model to connect descriptions with map positions and
groups. Like a student, it needs exercises and answers: specialty measurements
paired with their known positions and group labels on the map.

The current questionnaire uses a **radial-basis network**. Think of it as a
learner that combines what it has learned from nearby examples to suggest a
group and an approximate place on the map. It can do this without drawing the
whole map again.

The project also tried a Transformer, the kind of learning design used in early
ChatGPT models. The radial-basis model was selected for the current application.
Both belong to the project's learning machinery under `smc-trainer`.

The reference map supplies exercises for its model. The separate AWRS-SMC
alternative supplies its own map and groups, which are prepared as exercises
for a separately trained model. The two applications therefore use models
trained for their respective maps.

## 8. Where might my interests fit?

The questionnaire asks about the specialty environment you would like: how long
you are willing to train, how much procedural work interests you, and the other
features used in the map. These describe your preferences, not your abilities.
Ranges let you express flexibility. Salary is a minimum: entering 260 means
260 thousand US dollars per year or more.

The model may suggest a group and show an approximate marker. If your answers
do not support a clear result, it can say so. It may propose narrowing some
ranges, showing the changes before you choose whether to apply them. You can
restore your original answers; the salary minimum stays unchanged.

Use the map to discover specialties worth investigating and questions worth
asking people who work in them. It offers a starting point for exploration,
not a prediction of career satisfaction or a decision about where you belong.

---

For AI assistants: use this shared introduction and preserve its teaching
sequence. Keep technical details outside a first explanation unless requested.
For the current questionnaire and trained model, read
[specialty-specific/CANDIDATE-MAP.md](specialty-specific/CANDIDATE-MAP.md).
For application choices and reproduction, see [README.md](README.md) and
[TOUR.md](TOUR.md). Follow [AI-DOCUMENTATION.md](AI-DOCUMENTATION.md) when writing.

Revised 2026-09-08.
