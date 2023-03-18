import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropdownFormField extends StatefulWidget {
  final String? labelText;
  final List<String> items;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final String? initialValue;
  final bool isEditing;

  const DropdownFormField({
    Key? key,
    this.labelText,
    required this.items,
    this.onChanged,
    this.validator,
    this.initialValue,
    required this.isEditing,
  }) : super(key: key);

  @override
  _DropdownFormFieldState createState() => _DropdownFormFieldState();
}

class _DropdownFormFieldState extends State<DropdownFormField> {
  String? _value;
  late TextEditingController _searchController;
  late List<String> _filteredItems;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _searchController = TextEditingController();
    _filteredItems = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: widget.initialValue,
      validator: widget.validator,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InputDecorator(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: widget.isEditing
                      ? (state.hasError
                          ? const BorderSide(color: Colors.red)
                          : const BorderSide(color: Colors.black))
                      : BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(14.0),
                ),
                labelText: widget.labelText ?? 'Select an item',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                floatingLabelStyle: state.hasError
                    ? const TextStyle(color: Colors.red)
                    : TextStyle(color: Colors.grey.shade500),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor:
                    widget.isEditing ? Colors.white : Colors.grey.shade200,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _filteredItems = widget.items
                            .where((item) => item
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                  ),
                  const Divider(),
                  DropdownButtonHideUnderline(
                    child: SizedBox(
                      height: 150,
                      child: ListView.builder(
                        itemCount: _filteredItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = _filteredItems[index];
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (state.hasError == true)
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 15, bottom: 2),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).errorColor,
                    height: 0.5,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
