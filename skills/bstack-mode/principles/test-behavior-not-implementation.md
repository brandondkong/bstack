# Test Behavior, Not Implementation

**Applies when** you write, change, or keep a test.

A test calls the code the way its users do and asserts the result they observe against a literal expected value.

**The check:** would the test still pass if every function it imports returned `undefined`? If yes, it observes no behavior and cannot fail for a defect. Rewrite the assertion or delete the test.

**Why:** a test that cannot fail for a defect costs CI time and review attention and catches nothing. A test that pins a constant also blocks legitimate edits to that constant.

Shapes that still pass when everything returns `undefined`:

- **Weak or no assertion.** No `expect`, or only `toBeDefined`, `toBeTruthy`, `not.toThrow`, `toBeGreaterThan(0)`.
- **Mock or absence only.** Only `toHaveBeenCalled`, `toBeUndefined`, `toEqual([])`, `not.toBe(wrongValue)`.
- **Self-referential.** The expected value comes from the code under test: `expect(f(a)).toBe(f(a))`.
- **Constant pin.** The assertion restates a config default, table row, or prompt string.
- **Fixture asserts fixture.** The assertion reads data the test built, and the subject never runs.

**The fix:** call the subject in the test body with one concrete input and assert the literal output or observable effect, e.g. `expect(slugify("Hello, World!")).toBe("hello-world")`. For an absence, assert the presence on another input in the same test. For a mock, assert the payload it received or the state afterward, not that it was called. When no such assertion exists, delete the test.

**Keep** tests of a relation across rows (a key present in two tables) and compile-time type tests.
