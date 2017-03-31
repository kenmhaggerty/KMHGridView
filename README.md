# KMHGridView
Subclass of UIStackView for grids. Includes subscripting for easy view retrieval, e.g., `UIView *cell = gridView[row][col]`.

## To Do
- Make KMHGridView `IBDESIGNABLE` so that rows / columns show up in storyboard.

> I could not get the interface in storyboard to update when `rows` / `cols` were changed. See [NSHipster](http://nshipster.com/ibinspectable-ibdesignable/).

- Add KMHGridViewCell for easier cell generation.

> This should probably be a subclass of UIView?

- Add Swift version.

> I'm familiar with Swift but less familiar with functional programming. This is also a lower personal priority.
