#ifndef VIDYA_MODSECLOG_SECTION_H
#define VIDYA_MODSECLOG_SECTION_H

#include <boost/spirit/include/qi.hpp>
#include <iostream>
#include <string>

namespace vidya
{
    namespace modseclog
    {
        namespace qi    = boost::spirit::qi;
        namespace ascii = qi::ascii;

        using qi::phrase_parse;
        using qi::char_;
        using qi::space;
        using qi::lit;
        using qi::repeat;
        using ascii::alnum;

        struct Section
        {
            std::string hash;
            char name;

            Section()
                : name( '\0' )
            {
            }

            bool parse( auto &&itr_begin, auto const &itr_end )
            {
                auto first = itr_begin;

                // --1dc01a0d-A--
                bool result = phrase_parse( itr_begin,
                                            itr_end,
                                            repeat( 2, 2 )[lit( '-' )] >> +alnum >>
                                                lit( '-' ) >> char_,
                                            space,
                                            hash,
                                            name );

                if( first == itr_begin )
                {
                    return false;
                }

                return result;
            }
        };
    }
}

#endif
