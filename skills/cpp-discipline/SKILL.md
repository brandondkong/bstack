---
name: cpp-discipline
description: C++ rules for ownership, lifetime, const-correctness, error handling, and header hygiene. Loads when reading or editing .cpp, .cc, .hpp, or .h files.
paths: "**/*.cpp,**/*.cc,**/*.cxx,**/*.hpp,**/*.hh,**/*.h"
---

# C++ discipline

## Read the project's own rules first

Before writing C++ in a repo you have not touched this session, read what the build already declares. `meson.build` or `CMakeLists.txt` gives you the standard (`cpp_std`), the warning level, and the real dependencies. `.clang-format` gives you the layout, so never hand-format. A dependency declared `required: false` is optional at runtime, and code behind it must degrade rather than assume.

Match the standard the project sets. C++20 idioms in a C++17 project are a build break, not an improvement.

## Ownership is the design

Say who owns each object in the type, not in a comment.

- A value member for exclusive ownership, `unique_ptr` when it must be polymorphic or heap-allocated, `shared_ptr` only when lifetime is genuinely shared and you can name the second owner.
- A raw pointer or reference is a non-owning view. A function that takes `T*` does not free it. Never call `new` or `delete` in ordinary code.
- Every resource that is not memory gets the same treatment: a file descriptor, a socket, a lock, a device handle. Wrap it in a type whose destructor releases it, then the error paths take care of themselves.
- Returning a reference or a `string_view` into something the caller does not own outlives nothing. Return by value unless you can name what keeps the referent alive.

## Const and interfaces

Mark member functions `const` when they do not mutate observable state, and take parameters by `const&` when you only read them. Take by value when you will store a copy anyway, and let the move happen.

Design the interface so misuse does not compile. Prefer an enum class to a `bool` parameter, a named struct to three same-typed arguments in a row, and a strong typedef to a bare `int` that means milliseconds. This is `../bstack-mode/principles/type-system-discipline.md` in C++ form.

Keep headers thin. Forward declare where you can, include what you use, and keep implementation details in the `.cpp`. A header that pulls in half the project makes every build slower and every change wider.

## Errors

Decide the project's error strategy by reading existing code, then follow it. Exceptions and a result type are both defensible. Mixing them at random is not.

Validate at the boundary where untrusted data arrives, then trust your own types inside (`../bstack-mode/principles/boundary-discipline.md`). A function that re-checks what its own callers already guaranteed is noise.

Never silence an error to make a crash go away. A crash localizes the bug; a swallowed error relocates it somewhere harder (`../bstack-mode/principles/fix-root-causes.md`).

## Undefined behavior is not a style question

Treat these as defects, not preferences, because the compiler is allowed to assume they never happen:

- Reading an uninitialized value, or using an object after it moved from or was destroyed.
- Indexing past the end, including the off-by-one in a loop bound you edited.
- Signed integer overflow, and shifting by more than the width.
- Iterator or reference invalidation after the container reallocates. Any `push_back` can invalidate.
- A data race. Two threads, one write, no synchronization, no exceptions to this rule.

Compiler warnings at a high warning level are findings, not noise. When the build is warning-clean, keep it that way, and never suppress a warning without a comment saying what makes the code correct.

## Prove it

A C++ change that compiles is not a C++ change that works. Run the binary or the test (`../bstack-mode/principles/prove-it-works.md`).

For a memory or lifetime bug, reach for a sanitizer before reading the code a third time. AddressSanitizer and UndefinedBehaviorSanitizer find in one run what an afternoon of staring misses. `-fsanitize=address,undefined` on a debug build is usually a one-line change to the build file.

For concurrency, ThreadSanitizer. For a leak that only shows under load, measure RSS across a run rather than guessing from the diff.
