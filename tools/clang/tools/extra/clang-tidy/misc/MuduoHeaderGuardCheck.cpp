//===--- MuduoHeaderGuardCheck.cpp - clang-tidy----------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "MuduoHeaderGuardCheck.h"
#include "clang/AST/ASTContext.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"

using namespace clang::ast_matchers;

namespace clang {
namespace tidy {
namespace misc {

MuduoHeaderGuardCheck::MuduoHeaderGuardCheck(StringRef Name,
                                             ClangTidyContext *Context)
    : HeaderGuardCheck(Name, Context) {
  std::string Pattern = Options.getLocalOrGlobal("MuduoRootDirectory", "/muduo/");
  std::string AbsolutePath = tooling::getAbsolutePath(Context->getCurrentFile());
  size_t PosMuduo = AbsolutePath.find(Pattern);
  if (PosMuduo != StringRef::npos)
    MuduoRootDirectory = AbsolutePath.substr(0, PosMuduo + Pattern.size());
}

bool MuduoHeaderGuardCheck::shouldFixHeaderGuard(StringRef Filename) {
  return StringRef(tooling::getAbsolutePath(Filename)).startswith(MuduoRootDirectory);
}

bool MuduoHeaderGuardCheck::shouldSuggestToAddHeaderGuard(StringRef Filename) {
  // FIXME: only suggest to add if there is no #pragma once.
  return false;
}

std::string MuduoHeaderGuardCheck::formatEndIf(StringRef HeaderGuard) {
  return "endif  // " + HeaderGuard.str();
}

std::string MuduoHeaderGuardCheck::getHeaderGuard(StringRef Filename,
                                                  StringRef OldGuard) {
  std::string Guard = tooling::getAbsolutePath(Filename);
  if (StringRef(Guard).startswith(MuduoRootDirectory))
    Guard = Guard.substr(MuduoRootDirectory.size());

  std::replace(Guard.begin(), Guard.end(), '/', '_');
  std::replace(Guard.begin(), Guard.end(), '.', '_');
  std::replace(Guard.begin(), Guard.end(), '-', '_');

  // For examples/, use MUDUO_EXAMPLES_
  if (!StringRef(Guard).startswith("muduo"))
    Guard = "MUDUO_" + Guard;

  return StringRef(Guard).upper();
}

} // namespace misc
} // namespace tidy
} // namespace clang
