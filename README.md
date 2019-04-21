# restic-run

> Wrappers that make restic more cronable

I want to deploy five very similar restic clients, and had to come up with a
way to deploy, configure, "run" (cron) and monitor these backups.

Then I went totally crazy and made sure that you can use these scripts, too.

Note that these scripts are purely optional.  Nothing about the repository
is changed in any way, so `restic -r …` still works.  However, they do make it
easier to keep the configuration in a single, central file.

## Table of Contents

- [Background](#background)
- [Install](#install)
- [Usage](#usage)
- [How to make a new server](#how-to-make-a-new-server)
- [Shortcomings](#shortcomings)
- [TODOs](#todos)
- [Contribute](#contribute)

## Background

I needed to:

- Deploy 5 restic clients, and keep them similar enough without losing sanity even further.  This repo makes this easy.
- Execute all backups via cron, without exposing passwords in the command invocation, and without having dozens of arguments.  These scripts keep the configuration down to a single, minimal `params` file.
- Have some monitoring option to check how it's doing.  `restic-check-age` can be used inside cron, which is what I'm using for everything else already.
- Keep the server as simple as possible.  Thanks restic, for providing the `sftp` backend.

So there's that.

## Install

You don't need to copy the binaries, and can just use them from your git clone.
However, you may find it convenient to copy the content of `bin/` to somewhere on your `$PATH`.
Maybe `/usr/local/bin/`, maybe `~/bin/`, whatever you like.

You *do* need to create a new profile.  For example, the profile "default" will reside in `~/.config/restic-run/default/`.
You can either copy the folder `profile-template/` by hand, or just run `create-restic-profile.sh PROFILE_NAME`.

Finally, fill in the details in `params` of your profile.

For extra security, ask the server admin to provide an initial "known_hosts" file.

## Usage

After creating a profile, you're good to go.

All the commands take a profile name as first argument, and read all the details from there.
This way, the password is only stored in a single, user-only readable location, and revealed on the process list.

### Creating a repository

`$ restic-heimdal default init`

### Things that should go on your crontab

Make a backup, if the server is up: `restic-run-backup default`

Check that the last backup wasn't too long ago: `restic-check-age default`

For example, here are my (future?) crontab entries:
```
19-59/20 * * * * /usr/local/bin/restic-run-backup default
16 6 * * * /usr/local/bin/restic-check-age default
```

### Show the time of the last backup

`$ restic-last-backup default`

### Run normal restic commands

Show snapshots:
`$ restic-heimdal default snapshots`

Check integrity, read *all* data:
`$ restic-heimdal default check --read-data`

Restore single file:
`$ restic-heimdal default restore 79766175 --target /tmp/restore-work --include /work/foo`

### Run advanced restic commands

Remove old snapshots. `--dry-run` is only there to prevent over-eager copy-pasting.  Leave it out to actually remove snapshots:
`$ restic-heimdal default forget --dry-run --prune --group-by host,tags --keep-last 10 --keep-hourly 25 --keep-daily 8 --keep-weekly 6 --keep-monthly 13 --keep-yearly 50`

Mount snapshots for easier inspection and restoration:
`$ mkdir mnt-here && restic-heimdal default mount mnt-here`

Many other niceties:
`$ restic help`

### Caveats

#### `forget` has weird semantics

`forget` by default groups snapshots by their set of paths, and does not consider paths to be the main thing.  Example: I make three snapshots, of A, A&B, and only A again.  So the second snapshot had two paths.  Then `forget` considers the A&B snapshot to be something completely different than the A snapshots.  So `forget --keep-last 2` would do nothing, because it tries to keep the last two A-only snapshots, and it tries to keep the last 2 A&B snapshots.  This could cause trouble if the list of backed-up files changes slightly.  To get around this,

To get around this, use `forget` with the options `--group-by host,tags` or just `--group-by host`.

## How to make a new server

You only really need sftp access to something with a large harddrive.

I'm using an RPi with the sshd options `ChrootDirectory /path/to/that/drive` and `ForceCommand sftp-internal`.

## Shortcomings

### Serious

- restic uses a LUKS-like distinction between Master Key and Key Slot.  This means that you can change the password without having to rewrite the entire repository.  It also means that if keyslot *and* password are leaked, an adversary can recover all snapshots – duh.  The unintuitive part is that this can happen in any order: If the attacker can first obtain the keyslot (i.e., `keys/81270d89846052b906f10a24fa14f9bbb8d2e98f18b9732d56f8dfa8e026aa0f`), and months later the password to it, then the attacker can decrypt the entire repository, *even* if the user tries to revoke the key.  So, keep your password safe.
- No built-in redundancy.  A bit flip on the server in a block that is still in use could potentially destroy a large chunk of the backup.

### Ehh, whatever

- The password is moved via environment variables.  Don't go too crazy on the special characters.
- Restore-Verification can only be done by the client, as it requires the password.  This has the unfortunate effect that `RESTIC_READ_SUBSET_FRACTION` needs to be large (so, technically, represent a small fraction of the repository).
- If the client fails to even run `restic-check-age` at all, the user might not notice.  On the other hand, in that case the device is probably crashed and burned anyway.

## TODOs

- Deploy it at home and see how well it works
- Host all my friends' backups
- Convince everyone to host my backups

## Contribute

Feel free to dive in! [Open an issue](https://github.com/BenWiederhake/restic-run/issues/new) or submit PRs.
