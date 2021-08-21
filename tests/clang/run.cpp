#include <iostream>
#include <clang-c/Index.h>  // This is libclang.
using namespace std;

int main()
{
  CXIndex index = clang_createIndex(0, 0);
  CXTranslationUnit unit = clang_parseTranslationUnit(
    index,
    "run.cpp", nullptr, 0,
    nullptr, 0,
    CXTranslationUnit_None);
  if (unit == nullptr)
  {
    cerr << "Unable to parse translation unit. Quitting." << endl;
    exit(-1);
  }
  cout << "Things worked." << endl;

  clang_disposeTranslationUnit(unit);
  clang_disposeIndex(index);
}
