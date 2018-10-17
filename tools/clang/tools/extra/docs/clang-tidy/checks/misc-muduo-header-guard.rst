.. title:: clang-tidy - misc-muduo-header-guard

misc-muduo-header-guard
=======================

Finds and fixes header guards that do not adhere to Muduo style.

Options
-------

.. option:: MuduoRootDirectory

   A string to identify muduo root directory from the absolute path.
   Default is "/muduo/".  For /home/schen/muduo/muduo/base/Thread.cc,
   fine "/muduo/" and truncate the rest, we get /home/schen/muduo/.
