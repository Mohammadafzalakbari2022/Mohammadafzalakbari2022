import 'package:flutter/material.dart';
import 'package:pride_v3/app/responsive_breakpoints.dart';

/// Icon-first search row: tap search to expand a [SearchBar]; optional filter action.
class CompactSearchToolbar extends StatefulWidget {
  const CompactSearchToolbar({
    super.key,
    required this.searchController,
    required this.searchHint,
    required this.onSearchChanged,
    this.onFilterTap,
    this.filterActive = false,
    this.leading = const [],
    this.trailing = const [],
    this.searchTooltip,
    this.filterTooltip,
  });

  final TextEditingController searchController;
  final String searchHint;
  final VoidCallback onSearchChanged;
  final VoidCallback? onFilterTap;
  final bool filterActive;
  final List<Widget> leading;
  final List<Widget> trailing;
  final String? searchTooltip;
  final String? filterTooltip;

  @override
  State<CompactSearchToolbar> createState() => _CompactSearchToolbarState();
}

class _CompactSearchToolbarState extends State<CompactSearchToolbar> {
  var _searchExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.searchController.text.isNotEmpty) {
      _searchExpanded = true;
    }
  }

  void _toggleSearch() {
    setState(() => _searchExpanded = !_searchExpanded);
  }

  void _clearSearch() {
    widget.searchController.clear();
    widget.onSearchChanged();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = widget.searchController.text.isNotEmpty;
    final searchActive = _searchExpanded || hasQuery;

    final horizontal =
        prideContentHorizontalPadding(MediaQuery.sizeOf(context).width);
    return Padding(
      padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ...widget.leading,
              if (widget.leading.isNotEmpty) const SizedBox(width: 4),
              Tooltip(
                message: widget.searchTooltip ?? widget.searchHint,
                child: IconButton(
                  icon: Icon(
                    searchActive ? Icons.search : Icons.search_outlined,
                    color: searchActive
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  onPressed: _toggleSearch,
                ),
              ),
              if (widget.onFilterTap != null) ...[
                Tooltip(
                  message: widget.filterTooltip ?? '',
                  child: Badge(
                    isLabelVisible: widget.filterActive,
                    smallSize: 8,
                    child: IconButton(
                      icon: Icon(
                        widget.filterActive
                            ? Icons.filter_list
                            : Icons.filter_list_outlined,
                        color: widget.filterActive
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      onPressed: widget.onFilterTap,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              ...widget.trailing,
            ],
          ),
          AnimatedCrossFade(
            firstCurve: Curves.easeOut,
            secondCurve: Curves.easeIn,
            sizeCurve: Curves.easeInOut,
            crossFadeState: _searchExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: SearchBar(
                hintText: widget.searchHint,
                controller: widget.searchController,
                leading: const Icon(Icons.search),
                trailing: [
                  if (hasQuery)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      tooltip: MaterialLocalizations.of(context)
                          .clearButtonTooltip,
                      onPressed: _clearSearch,
                    ),
                ],
                onChanged: (_) {
                  widget.onSearchChanged();
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
