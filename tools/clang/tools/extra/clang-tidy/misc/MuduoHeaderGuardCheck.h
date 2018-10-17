//===--- MuduoHeaderGuardCheck.h - clang-tidy--------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_CLANG_TOOLS_EXTRA_CLANG_TIDY_MISC_MUDUOHEADERGUARDCHECK_H
#define LLVM_CLANG_TOOLS_EXTRA_CLANG_TIDY_MISC_MUDUOHEADERGUARDCHECK_H

#include "../ClangTidy.h"
#include "../utils/HeaderGuard.h"

namespace clang {
namespace tidy {
namespace misc {

/// Finds and fixes header guards that do not adhere to Muduo style.
///
/// For the user-facing documentation see:
/// http://clang.llvm.org/extra/clang-tidy/checks/misc-muduo-header-guard.html
class MuduoHeaderGuardCheck : public utils::HeaderGuardCheck {
public:
  MuduoHeaderGuardCheck(StringRef Name, ClangTidyContext *Context);

  bool shouldFixHeaderGuard(StringRef Filename) override;
  bool shouldSuggestToAddHeaderGuard(StringRef Filename) override;
  std::string formatEndIf(StringRef HeaderGuard) override;
  std::string getHeaderGuard(StringRef Filename, StringRef OldGuard) override;

private:
  std::string MuduoRootDirectory;
};

} // namespace misc
} // namespace tidy
} // namespace clang

#endif // LLVM_CLANG_TOOLS_EXTRA_CLANG_TIDY_MISC_MUDUOHEADERGUARDCHECK_H
