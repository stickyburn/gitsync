module main

import os

struct GitRepos {
mut:
	git_repos  []string
	repo_count int
	skip_count int
}

fn is_git_repo(path string) bool {
	return os.exists(os.join_path(path, '.git'))
}

fn find_git_repo(path string, mut info GitRepos) {
	dirs := os.ls(path) or { return }

	for dir in dirs {
		if info.repo_count >= 10 || info.skip_count >= 2 {
			return
		}

		full_path := os.join_path(path, dir)
		if os.is_dir(full_path) {
			if is_git_repo(full_path) {
				println('${full_path} ${dir}')
				info.repo_count++
				info.git_repos << full_path
			} else {
				info.skip_count++
			}
		}
	}
}

fn main() {
	mut info := GitRepos{}
	find_git_repo(os.getwd().trim('gitsync'), mut info)
}
