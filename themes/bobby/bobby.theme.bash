# shellcheck shell=bash
# shellcheck disable=SC2034 # Expected behavior for themes.

SCM_THEME_PROMPT_DIRTY=" ${red?}✗"
SCM_THEME_PROMPT_CLEAN=" ${bold_green?}✓"
SCM_THEME_PROMPT_PREFIX=" ${green?}|"
SCM_THEME_PROMPT_SUFFIX="${green?}|"

GIT_THEME_PROMPT_DIRTY=" ${red?}✗"
GIT_THEME_PROMPT_CLEAN=" ${bold_green?}✓"
GIT_THEME_PROMPT_PREFIX=" ${green?}|"
GIT_THEME_PROMPT_SUFFIX="${green?}|"

RVM_THEME_PROMPT_PREFIX="|"
RVM_THEME_PROMPT_SUFFIX="|"

function __bobby_clock() {
	printf '%s' "$(clock_prompt) "

	if [[ "${THEME_SHOW_CLOCK_CHAR:-}" == "true" ]]; then
		printf '%s' "$(clock_char) "
	fi
}

function __check_conda() {
	if [ "${CONDA_DEFAULT_ENV}" == "" ]; then
		printf ""
	else
		printf "(${CONDA_DEFAULT_ENV}) "
	fi
}

function __check_environment() {
	if [ -n "${BEAKER_JOB_ID:-}" ]; then
		# In Beaker session - show only Beaker indicator
		printf "${bold_blue?}[BEAKER]${reset_color?} "
	elif [ -f /.dockerenv ] || grep -q docker /proc/1/cgroup 2>/dev/null; then
		# In Docker but not Beaker - show Docker indicator
		printf "${bold_blue?}[DOCKER]${reset_color?} "
	else
		# Not in Docker or Beaker
		printf ""
	fi
}

# In your prompt command function, replace both checks with:
PS1+="$(__check_environment)"

function prompt_command() {
	PS1="\n$(battery_char) $(__bobby_clock)"
	PS1+="${yellow?}$(ruby_version_prompt)"
	PS1+="${purple?}\h "
	PS1+="$(__check_environment)"
	PS1+="${reset_color?}in "
	PS1+="${green?}\w\n"
	PS1+="$(__check_conda)"
	PS1+="${bold_cyan?}$(scm_prompt_char_info) "
	PS1+="${green?}→${reset_color?} "
}

: "${THEME_SHOW_CLOCK_CHAR:="true"}"
: "${THEME_CLOCK_CHAR_COLOR:=${red?}}"
: "${THEME_CLOCK_COLOR:=${bold_cyan?}}"
: "${THEME_CLOCK_FORMAT:="%Y-%m-%d %H:%M:%S"}"

safe_append_prompt_command prompt_command
