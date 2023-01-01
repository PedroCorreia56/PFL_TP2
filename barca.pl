:- consult('display.pl').
:- consult('inputs.pl').
:- consult('menu.pl').
:- consult('play.pl').
:- consult('logic.pl').
:-use_module(library(lists)).
:-use_module(library(system)).
:-use_module(library(random)).
% Start game predicate
barca :-
  play.