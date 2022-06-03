// Copyright 2022 Olaf <ibis-hdl@users.noreply.github.com>.
// SPDX-License-Identifier: GPL-3.0-only

#include <fmt/format.h>
#include <fmt/ostream.h>

#include <iostream>

int main()
{
    std::cout << fmt::format("Hello {0}!\n", "World");
    return 0;
}
