// This file is part of the "jQuery.Syntax" project, and is distributed under the MIT License.
Syntax.lib.rubyStyleFunction={pattern:/(?:def\s+|\.)([a-z_][a-z0-9_]+)/gi,matches:Syntax.extractMatches({klass:"function"})};Syntax.lib.rubyStyleSymbol={pattern:/([:]?):\w+/g,klass:"constant",matches:function(a,b){return""!=a[1]?[]:[new Syntax.Match(a.index,a[0].length,b,a[0])]}};
Syntax.register("ruby",function(a){a.push(["private","protected","public"],{klass:"access"});a.push(["self","super","true","false","nil"],{klass:"constant"});a.push({pattern:/(\%[\S])(\{[\s\S]*?\})/g,matches:Syntax.extractMatches({klass:"function"},{klass:"constant"})});a.push({pattern:/`[^`]+`/g,klass:"string"});a.push({pattern:/\#\{([^\}]*)\}/g,matches:Syntax.extractMatches({brush:"ruby",only:["string"]})});a.push(Syntax.lib.rubyStyleRegularExpression);a.push({pattern:/(@+|\$)[\w]+/g,klass:"variable"});
a.push(Syntax.lib.camelCaseType);a.push("alias and begin break case class def define_method defined? do else elsif end ensure false for if in module next not or raise redo rescue retry return then throw undef unless until when while yield block_given?".split(" "),{klass:"keyword"});a.push("+*/-&|~!%<=>".split(""),{klass:"operator"});a.push(Syntax.lib.rubyStyleSymbol);a.push(Syntax.lib.perlStyleComment);a.push(Syntax.lib.webLink);a.push(Syntax.lib.singleQuotedString);a.push(Syntax.lib.doubleQuotedString);
a.push(Syntax.lib.stringEscape);a.push(Syntax.lib.decimalNumber);a.push(Syntax.lib.hexNumber);a.push(Syntax.lib.rubyStyleFunction);a.push(Syntax.lib.cStyleFunction)});
