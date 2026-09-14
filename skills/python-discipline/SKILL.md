---
name: python-discipline
description: Python rules for typing at boundaries, error handling, data shapes, and test honesty. Loads when reading or editing .py files.
paths: "**/*.py,**/*.pyi"
---

# Python discipline

## Read the project's own rules first

Before writing Python in a repo you have not touched this session, read its config. `ruff.toml` or `pyproject.toml` gives you the target version, the line length, and which lint rules are actually on. A narrow `select` list is a deliberate choice, so do not "fix" code for rules the project does not enable. Check for a type checker config before assuming annotations are enforced anywhere.

Never hand-format. If the project formats with ruff or black, run it.

## Name the shape

Python will let you pass a dict of anything anywhere. That is the problem, not the feature.

- Give every structure that crosses a function boundary a name: a dataclass, a `NamedTuple`, or a `TypedDict` for data you did not define. A dict with known keys is a class that has not been written yet.
- Annotate function signatures, especially at module boundaries and public entry points. Inside a short local helper, annotations can be noise. At the edges they are documentation the reader can trust.
- Use an enum instead of string literals for a closed set of values. A typo in a string constant is a runtime surprise, and a typo in an enum member is an immediate error.
- Prefer `pathlib.Path` to string paths, and pass the `Path` around rather than converting at every call site.

This is `../bstack-mode/principles/type-system-discipline.md` and `../bstack-mode/principles/model-the-domain.md` applied to a dynamic language, where the compiler will not catch you.

## Errors

Catch the exception you can actually handle, and let the rest propagate. `except Exception` at an interior layer turns a specific failure into a mystery two frames up. Bare `except:` also catches `KeyboardInterrupt`, so it is always wrong.

When you re-raise with context, use `raise NewError(...) from err` so the original traceback survives.

Validate untrusted input where it enters: argv, environment, config files, network payloads, subprocess output. After that boundary, trust your own types (`../bstack-mode/principles/boundary-discipline.md`). Parse into the named shape at the edge instead of checking `if "key" in data` in five places downstream.

## Traps worth knowing

- A mutable default argument is shared across calls. Use `None` and build inside the function.
- A closure in a loop captures the variable, not its value. Bind it with a default argument or a factory.
- `is` compares identity. Use it for `None`, `True`, and `False`, never for numbers or strings.
- A generator is consumed once. If you iterate it twice, the second pass sees nothing.
- Module-level code runs on import. Keep side effects out of it, behind `if __name__ == "__main__":` or a function.
- Floating-point equality. Compare with a tolerance, or use `Decimal` where exactness is the requirement.

## Tests

Assert the value the caller observes, against a literal (`../bstack-mode/principles/test-behavior-not-implementation.md`). `assert result` and `assert mock.called` pass when the code is broken.

Patch the name where it is looked up, not where it is defined. Prefer passing a fake in as an argument over patching at all; a function that takes its dependency is easier to test and easier to read.

Use `pytest.raises` with `match=` so the test pins which failure occurred, not merely that something failed.

## Prove it

Run the code, not the linter (`../bstack-mode/principles/prove-it-works.md`). An import-time error, a missing dependency, and a wrong path all pass every static check.

When behavior differs between your shell and the app, suspect the environment before the code: the interpreter on `PATH`, the active virtualenv, an editable install pointing somewhere stale, a `PYTHONPATH` set by the runner. Print `sys.executable` and the resolved module file rather than guessing.
